#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$SCRIPT_DIR/dist"
BUILDER_NAME="roaringlite-build-$$"

mkdir -p "$DIST_DIR"

cleanup() {
  docker buildx rm "$BUILDER_NAME" --force 2>/dev/null || true
}
trap cleanup EXIT

docker buildx create --name "$BUILDER_NAME" --use

docker buildx build -f "$SCRIPT_DIR/build.Dockerfile" \
  --builder "$BUILDER_NAME" \
  --output "type=local,dest=$DIST_DIR" \
  "$SCRIPT_DIR"
