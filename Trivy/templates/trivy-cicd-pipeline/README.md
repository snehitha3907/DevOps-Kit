# last_verified: 2026-10-15 · Trivy 0.58.1
# Trivy CI/CD Pipeline Template for Container Scanning
# Based on: https://trivy.dev/docs/latest/guide/advanced/private-registries/ecr [source: https://trivy.dev/docs/latest/guide/advanced/private-registries/ecr]

# Trivy CI/CD Pipeline Template for Container Scanning

This template provides a complete CI/CD pipeline configuration for integrating Trivy container security scanning into your software delivery process. It includes both GitHub Actions and GitLab CI configurations, along with helper scripts and configuration files.

## Purpose

Container image scanning is a critical component of modern DevSecOps practices. This template helps you:

- Scan container images for vulnerabilities using Trivy
- Perform filesystem scans on source code to catch issues early
- Generate and scan Software Bills of Materials (SBOMs) for supply chain security
- Fail builds when critical or high-severity vulnerabilities are detected
- Provide detailed SARIF reports for integration with security dashboards

## Template Structure

```
trivy-cicd-pipeline/
├── .github/
│   └── workflows/
│       └── trivy-security-scan.yml     # GitHub Actions workflow
├── .gitlab-ci.yml                      # GitLab CI pipeline
├── trivy-config.yaml                   # Trivy configuration
├── merge-sboms.py                      # Python SBOM merging helper
└README.md                              # This file
```

## Usage

### GitHub Actions

1. Copy the `.github/workflows/trivy-security-scan.yml` file to your repository's `.github/workflows/` directory
2. Ensure you have the necessary secrets configured:
   - `GITHUB_TOKEN` (automatically provided by GitHub Actions)
3. The workflow will trigger on push and pull request events to main/master branches

### GitLab CI

1. Copy the `.gitlab-ci.yml` file to your repository's root directory
2. Ensure you have runners configured with Docker and security tags
3. The pipeline will trigger on push events to all branches

## How It Works

The pipeline follows this sequence:

1. **Build**: Construct and push the Docker image to your container registry
2. **Test**: Run Trivy filesystem scan on the source code to catch issues early
3. **Scan**: 
   - Pull the built image and run Trivy image scan (the gatekeeping scan)
   - Generate an SBOM and run Trivy SBOM scan for supply chain verification
4. **Deploy**: (Optional) Deploy the image if all scans pass

## Configuration

### Trivy Configuration (`trivy-config.yaml`)

The template includes a pre-configured Trivy configuration file that:
- Scans for vulnerabilities, secrets, and misconfigurations
- Focuses on CRITICAL and HIGH severity issues
- Ignores unknown vulnerability status and unfixed vulnerabilities
- Skips vendor and node_modules directories during scanning

### Severity Levels

The template uses `CRITICAL,HIGH` as the default severity threshold for scanning gates. This can be adjusted by modifying the `TRIVY_SEVERITY` variable in the pipeline configurations.

### Exit Codes

Trivy is configured to exit with code 1 when findings are detected at or above the specified severity threshold, causing the pipeline step to fail.

## Output Formats

All Trivy scans in this template generate SARIF (Static Analysis Results Interchange Format) files for seamless integration with:
- GitHub Security tab (code scanning alerts)
- GitLab Security Dashboard
- Other SARIF-compatible security tools

## Common Errors and Troubleshooting

### Authentication Errors with Private Registries

**Symptom**: `Failed to pull image` or `Unauthorized: authentication required` errors during image pull steps.

**Solution**: Ensure your CI/CD runners have appropriate credentials to access your container registry:
- For GitHub Actions: Configure `docker/login-action` with appropriate credentials
- For GitLab CI: Ensure runners have access to the container registry or use `CI_REGISTRY_IMAGE` variable

### SARIF Generation and Upload Issues

**Symptom**: SARIF files not generated or not picked up by security dashboards.

**Solution**: 
- Verify that Trivy commands include `--format sarif --output <filename>.sarif` arguments
- Check that the SARIF file paths in artifact/report configurations match the actual output paths
- Ensure SARIF files are valid JSON (you can validate with `jq . <filename>.sarif > /dev/null`)

### SBOM Generation Failures

**Symptom**: Errors during SBOM generation or scanning steps.

**Solution**:
- The template includes a placeholder SBOM generation step
- Replace the placeholder with your actual SBOM generation tool (e.g., Syft, CycloneDX-Bom)
- Ensure the generated SBOM is in a format Trivy can read (CycloneDX or SPDX)

## Rollback Procedures

If a security scan fails and prevents deployment:

1. **Investigate**: Review the detailed scan results in the SARIF files or job logs
2. **Remediate**: Address the identified vulnerabilities in your source code or dependencies
3. **Re-run**: Once fixes are committed, the pipeline will automatically re-run on the next push
4. **Emergency Override**: For critical situations, you can manually trigger a deployment after verifying the risk acceptance of any remaining findings

## Rollback Procedures

If a security scan fails and prevents deployment:

1. **Investigate**: Review the detailed scan results in the SARIF files or job logs
2. **Remediate**: Address the identified vulnerabilities in your source code or dependencies
3. **Re-run**: Once fixes are committed, the pipeline will automatically re-run on the next push
4. **Emergency Override**: For critical situations, you can manually trigger a deployment after verifying the risk acceptance of any remaining findings

## References

- Trivy Documentation: https://trivy.dev/docs/latest/guide/advanced/private-registries/ecr [source: https://trivy.dev/docs/latest/guide/advanced/private-registries/ecr]

## Verification

To verify the template is working correctly:

1. Commit a known vulnerable dependency to your repository
2. Push the changes to trigger the pipeline
3. Confirm that the appropriate security scan step fails with vulnerability details
4. Fix the vulnerability and verify the pipeline passes on the next run

## What's Next

Consider enhancing this template with:
- Integration with vulnerability management tools
- Custom policy checks using Rego or other policy engines
- Performance optimizations for large monorepos
- Additional scanning modes (config scanning for IaC, etc.)
- Automated remediation pull requests for dependency updates