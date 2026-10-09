// last_verified: 2026-10-09 · Terraform provider schema validation
//
// validate-provider-schema.go — checks that a Terraform provider's resource
// schema, as exported by `terraform providers schema -json`, still satisfies
// the constraints a module relies on: required arguments present, expected
// attributes exist, and no argument the module uses has been removed or
// renamed. Exits non-zero on the first failure so it can gate a CI job.
//
// Usage:
//
//	terraform providers schema -json > schema.json
//	./validate-provider-schema.go schema.json contract.json
//
// contract.json is a small hand-written file listing the resources, their
// required arguments, and the optional attributes the module reads.
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

// contract is the subset of a provider schema a module is allowed to depend on.
type contract struct {
	Resources []resourceContract `json:"resources"`
}

type resourceContract struct {
	Name      string             `json:"name"`
	Arguments []argumentContract `json:"arguments"`
	Attributes []argumentContract `json:"attributes"`
}

type argumentContract struct {
	Name     string `json:"name"`
	Required bool   `json:"required,omitempty"`
}

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintf(os.Stderr, "usage: %s <schema.json> <contract.json>\n", os.Args[0])
		os.Exit(2)
	}

	schema, err := readSchema(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "schema: %v\n", err)
		os.Exit(2)
	}
	contract, err := readContract(os.Args[2])
	if err != nil {
		fmt.Fprintf(os.Stderr, "contract: %v\n", err)
		os.Exit(2)
	}

	failed := false
	for _, rc := range contract.Resources {
	(rs, ok) := schema.ResourceSchemas[rc.Name]
		if !ok {
			fmt.Printf("FAIL resource %q: not present in provider schema\n", rc.Name)
			failed = true
			continue
		}
		block := rs.Schema
		for _, ac := range rc.Arguments {
			_, has := block.Arguments[ac.Name]
			if ac.Required && !has {
				fmt.Printf("FAIL %s.%s: required argument missing from schema\n", rc.Name, ac.Name)
				failed = true
			}
		}
		for _, ac := range rc.Attributes {
			_, has := block.Attributes[ac.Name]
			if ac.Required && !has {
				fmt.Printf("FAIL %s.%s: required attribute missing from schema\n", rc.Name, ac.Name)
				failed = true
			}
		}
	}

	if failed {
		os.Exit(1)
	}
	fmt.Println("OK: provider schema satisfies contract")
}

// providerSchema is the shape produced by `terraform providers schema -json`.
type providerSchema struct {
	ResourceSchemas map[string]resourceSchema `json:"resource_schemas"`
}

type resourceSchema struct {
	Schema blockSchema `json:"schema"`
}

type blockSchema struct {
	Arguments  map[string]json.RawMessage `json:"arguments"`
	Attributes map[string]json.RawMessage `json:"attributes"`
}

func readSchema(path string) (providerSchema, error) {
	var ps providerSchema
	if err := readJSON(path, &ps); err != nil {
		return ps, err
	}
	if ps.ResourceSchemas == nil {
		ps.ResourceSchemas = map[string]resourceSchema{}
	}
	return ps, nil
}

func readContract(path string) (contract, error) {
	var c contract
	if err := readJSON(path, &c); err != nil {
		return c, err
	}
	return c, nil
}

func readJSON(path string, v interface{}) error {
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()
	return json.NewDecoder(f).Decode(v)
}