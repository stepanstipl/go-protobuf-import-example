# Helper variables and Make settings
.PHONY: help clean build proto-link proto-vendor run
.DEFAULT_GOAL := help
.ONESHELL :
.SHELLFLAGS := -ec
SHELL := /bin/bash

help:                                  ## Print list of tasks
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_%-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' Makefile

build: clean proto-link                ## Build go project
	go build -o build/main main.go

clean:
	rm -rf vendor
	rm -rf protobuf-import
	rm -rf pb/*
	rm -rf build/*

proto-link:                            ## Generate go protobuf files using symlinked modules
	./protobuf-import.sh
	protoc -I ./protobuf-import -I ./ ./my.proto --go_out=plugins=grpc:./pb

proto-vendor:                          ## Generate go protobuf files using go mode vendor
	go mod vendor
	protoc -I ./vendor -I ./ ./my.proto --go_out=plugins=grpc:./pb

run:                                   ## Runs the demo server
	./build/main
