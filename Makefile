.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BOLD)$(CYAN)%-25s$(RESET)%s\n", $$1, $$2}'

.PHONY: conformance
conformance: ## Regenerate the conformance golden samples. Only to be run when changes are expected
	go run ./test/conformance/generator/ test/conformance/testdata/

.PHONY: conformance-test
conformance-test: ## Run the conformance test suite
	go test ./test/conformance/...

.PHONY: proto
proto: ## Rebuild protobuf autogenerated code
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install github.com/infobloxopen/protoc-gen-gorm@main
	protoc --proto_path=api --proto_path=$(GOPATH)/pkg/mod --go_out=pkg --gorm_out=pkg api/sbom.proto

.PHONY: fakes
fakes: ## Rebuild the fake implementations
	go generate ./...
