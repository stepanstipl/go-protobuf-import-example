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
run                            Runs the demo server
```
