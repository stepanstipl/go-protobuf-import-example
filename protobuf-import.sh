#!/usr/bin/env sh
set -emou pipefail

# Set parent directory to hold all the symlinks
PROTOBUF_IMPORT_DIR='protobuf-import'
mkdir -p "${PROTOBUF_IMPORT_DIR}"

# Remove any existing symlinks & empty directories
find "${PROTOBUF_IMPORT_DIR}" -type l -delete
find "${PROTOBUF_IMPORT_DIR}" -type d -empty -delete

# Download all the required dependencies
go mod download

# Get all the modules we use and create required directory structure
go list -f "${PROTOBUF_IMPORT_DIR}/{{ .Path }}" -m all | xargs -L1 dirname | sort | uniq | xargs mkdir -p

# Create synlinks
go list -f "{{ .Dir }} ${PROTOBUF_IMPORT_DIR}/{{ .Path }}" -m all | xargs -L1 -- ln -s
