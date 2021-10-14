#  go-protobuf-import-example

Example of how to import versioned protobuf definitions from Go packages when
using Go modules.

This code is to accompany my blog post [Importing protobuf definitions with Go
modules](https://stepan.wtf/importing-protobuf-with-go-modules/), please read
for more details.

## TL;DR

Symlink directories of individual modules (obtained from `go list`) under one
folder, or populate `vendor` directory by running `go mod vendor`. Paths within
that directory then match relative import paths used in protobuf `import`
statement and you can run `protoc` with `-I ./vendor` flag.

## Requirements

- `protoc`- https://github.com/protocolbuffers/protobuf
- `gogo/protobuf` - https://github.com/gogo/protobuf
- `go` v1.12+ - https://golang.org/

## Usage

Run `make` for help:

```console
$ make
help                           Print list of tasks
build                          Build go project
proto-link                     Generate go protobuf files using symlinked modules
proto-vendor                   Generate go protobuf files using go mode vendor
proto-source                   Generate go protobuf files using source path
run                            Runs the demo server
```

## Third Option: Download the Source

Import the proto source code directly into your Source Directory.

Go Modules refers to the `go` source code for a project. It doesn't make sense to use
the same import mechanism to satisfy dependencies of `proto` files, although it does work for
some repositories if `proto` files happen to exist in the `go` project.

1. Download the kubernetes source Code:
    ```bash
   GO111MODULE=off go get k8s.io/api
   GO111MODULE=off go get k8s.io/apimachinery # Dependency of k8s.io/api 
   ```

NOTE: Can git clone, choosing to use go get since it the repo is still a `go` repository.

2. Reference the Source Directory in Makefile using `-I $(GOPATH)/src`
   ```bash
   protoc -I $(GOPATH)/src \
      -I ./ ./my.proto \
      --gofast_out=plugins=grpc:./pb
   ```

3. Build proto files:
   ```bash
   go build -o build/main main.go
   ```

A caveat is that versions have to be manually changed/updated by going directly to the
directly and running the git commands to check out different tags/branches.