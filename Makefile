.PHONY: generate tidy

generate:
	oapi-codegen -config oapi-codegen.yaml ../spec/openapi.yaml

tidy:
	go mod tidy
