# last_verified: 2026-10-25 · helm 3.x

package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/chart/loader"
	"helm.sh/helm/v3/pkg/chartutil"
	"helm.sh/helm/v3/pkg/cli"
	"helm.sh/helm/v3/pkg/getter"
	"helm.sh/helm/v3/pkg/registry"
	"helm.sh/helm/v3/pkg/repo"
)

type ValidationResult struct {
	ChartPath    string   `json:"chart_path"`
	Valid        bool     `json:"valid"`
	Errors       []string `json:"errors,omitempty"`
	Warnings     []string `json:"warnings,omitempty"`
	Dependencies []DependencyInfo `json:"dependencies,omitempty"`
}

type DependencyInfo struct {
	Name       string   `json:"name"`
	Version    string   `json:"version"`
	Repository string   `json:"repository"`
	Condition  string   `json:"condition,omitempty"`
	Tags       []string `json:"tags,omitempty"`
	Enabled    bool     `json:"enabled"`
	Resolved   string   `json:"resolved,omitempty"`
	Error      string   `json:"error,omitempty"`
}

type ChartMetadata struct {
	Name       string            `yaml:"name"`
	Version    string            `yaml:"version"`
	Dependencies []chart.Dependency `yaml:"dependencies"`
}

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	command := os.Args[1]
	switch command {
	case "validate":
		if len(os.Args) < 3 {
			fmt.Fprintf(os.Stderr, "Error: chart path required\n")
			printUsage()
			os.Exit(1)
		}
		chartPath := os.Args[2]
		results := validateChartDependencies(chartPath)
		outputResults(results)
	case "check-versions":
		if len(os.Args) < 3 {
			fmt.Fprintf(os.Stderr, "Error: chart path required\n")
			printUsage()
			os.Exit(1)
		}
		chartPath := os.Args[2]
		results := checkVersionConstraints(chartPath)
		outputResults(results)
	case "help", "-h", "--help":
		printUsage()
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", command)
		printUsage()
		os.Exit(1)
	}
}

func printUsage() {
	fmt.Println(`helm-dep-validate - Custom Helm plugin for chart dependency validation and version constraint checking

Usage:
  helm dep-validate validate <chart-path>       Validate chart dependencies
  helm dep-validate check-versions <chart-path> Check version constraints against repositories
  helm dep-validate help                        Show this help

Commands:
  validate       Parse Chart.yaml and verify dependency syntax, conditions, and tags
  check-versions Resolve dependency versions against configured repositories

Examples:
  helm dep-validate validate ./my-chart
  helm dep-validate check-versions ./my-chart --output json
`)
}

func validateChartDependencies(chartPath string) []ValidationResult {
	var results []ValidationResult

	absPath, err := filepath.Abs(chartPath)
	if err != nil {
		results = append(results, ValidationResult{
			ChartPath: chartPath,
			Valid:     false,
			Errors:    []string{fmt.Sprintf("failed to resolve path: %v", err)},
		})
		return results
	}

	ch, err := loader.Load(absPath)
	if err != nil {
		results = append(results, ValidationResult{
			ChartPath: absPath,
			Valid:     false,
			Errors:    []string{fmt.Sprintf("failed to load chart: %v", err)},
		})
		return results
	}

	result := ValidationResult{
		ChartPath:    absPath,
		Valid:        true,
		Dependencies: []DependencyInfo{},
	}

	if ch.Metadata == nil {
		result.Valid = false
		result.Errors = append(result.Errors, "Chart.yaml missing or invalid")
		results = append(results, result)
		return results
	}

	for _, dep := range ch.Metadata.Dependencies {
		depInfo := DependencyInfo{
			Name:       dep.Name,
			Version:    dep.Version,
			Repository: dep.Repository,
			Condition:  dep.Condition,
			Tags:       dep.Tags,
			Enabled:    dep.Enabled,
		}

		if dep.Name == "" {
			result.Valid = false
			depInfo.Error = "dependency name is required"
		}
		if dep.Version == "" {
			result.Valid = false
			depInfo.Error = "dependency version is required"
		}
		if dep.Repository == "" {
			result.Warnings = append(result.Warnings, fmt.Sprintf("dependency %q has no repository URL", dep.Name))
		}

		if dep.Condition != "" {
			if !isValidCondition(dep.Condition) {
				result.Warnings = append(result.Warnings, fmt.Sprintf("dependency %q condition %q may not evaluate correctly", dep.Name, dep.Condition))
			}
		}

		result.Dependencies = append(result.Dependencies, depInfo)
	}

	if len(ch.Metadata.Dependencies) == 0 {
		result.Warnings = append(result.Warnings, "chart declares no dependencies")
	}

	results = append(results, result)
	return results
}

func isValidCondition(condition string) bool {
	condition = strings.TrimSpace(condition)
	if condition == "" {
		return false
	}
	parts := strings.Split(condition, ".")
	if len(parts) < 2 {
		return false
	}
	return true
}

func checkVersionConstraints(chartPath string) []ValidationResult {
	results := validateChartDependencies(chartPath)
	if len(results) == 0 || !results[0].Valid {
		return results
	}

	result := &results[0]
	settings := cli.New()
	providers := getter.All(settings)

	for i := range result.Dependencies {
		dep := &result.Dependencies[i]
		if dep.Repository == "" {
			dep.Error = "no repository configured for version resolution"
			result.Valid = false
			continue
		}

		resolved, err := resolveDependencyVersion(dep.Repository, dep.Name, dep.Version, providers)
		if err != nil {
			dep.Error = fmt.Sprintf("version resolution failed: %v", err)
			result.Valid = false
			continue
		}
		dep.Resolved = resolved
	}

	return results
}

func resolveDependencyVersion(repoURL, name, versionConstraint string, providers getter.Providers) (string, error) {
	if strings.HasPrefix(repoURL, "oci://") {
		return resolveOCIVersion(repoURL, name, versionConstraint)
	}

	chartRepo, err := repo.NewChartRepository(&repo.Entry{
		Name:                  name,
		URL:                   repoURL,
		PassCredentialsAll:    true,
	}, providers)
	if err != nil {
		return "", fmt.Errorf("failed to create repo client: %w", err)
	}

	index, err := chartRepo.DownloadIndexFile()
	if err != nil {
		return "", fmt.Errorf("failed to download index: %w", err)
	}

	versions, ok := index.Entries[name]
	if !ok || len(versions) == 0 {
		return "", fmt.Errorf("chart %q not found in repository", name)
	}

	sort.Slice(versions, func(i, j int) bool {
		return chartutil.CompareVersions(versions[i].Version, versions[j].Version) > 0
	})

	constraint, err := chartutil.NewConstraint(versionConstraint)
	if err != nil {
		return "", fmt.Errorf("invalid version constraint %q: %w", versionConstraint, err)
	}

	for _, cv := range versions {
		if constraint.Check(cv.Version) {
			return cv.Version, nil
		}
	}

	return "", fmt.Errorf("no version matching constraint %q found (available: %d versions)", versionConstraint, len(versions))
}

func resolveOCIVersion(repoURL, name, versionConstraint string) (string, error) {
	registryClient, err := registry.NewClient()
	if err != nil {
		return "", fmt.Errorf("failed to create OCI client: %w", err)
	}
	defer registryClient.Close()

	tags, err := registryClient.Tags(repoURL)
	if err != nil {
		return "", fmt.Errorf("failed to list OCI tags: %w", err)
	}

	constraint, err := chartutil.NewConstraint(versionConstraint)
	if err != nil {
		return "", fmt.Errorf("invalid version constraint %q: %w", versionConstraint, err)
	}

	for _, tag := range tags {
		if constraint.Check(tag) {
			return tag, nil
		}
	}

	return "", fmt.Errorf("no OCI tag matching constraint %q found", versionConstraint)
}

func outputResults(results []ValidationResult) {
	encoder := json.NewEncoder(os.Stdout)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(results); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to encode output: %v\n", err)
		os.Exit(1)
	}
}

func readChartMetadata(chartPath string) (*ChartMetadata, error) {
	data, err := os.ReadFile(chartPath)
	if err != nil {
		return nil, err
	}

	var meta ChartMetadata
	if err := yaml.Unmarshal(data, &meta); err != nil {
		return nil, err
	}
	return &meta, nil
}

func findChartYaml(dir string) (string, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return "", err
	}

	for _, e := range entries {
		if e.Name() == "Chart.yaml" || e.Name() == "Chart.yml" {
			return filepath.Join(dir, e.Name()), nil
		}
	}
	return "", fmt.Errorf("Chart.yaml not found in %s", dir)
}