#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage: $0 {build|train|eval} [puffer arguments...]"
    echo "  build  Build the patched drone environment"
    echo "  train  Train one drone per procedural forest (with auxiliary hover worlds)"
    echo "  eval   Evaluate forest worlds; pass --load-model-path as needed"
}

mode="${1:-}"
if [ -z "$mode" ]; then
    usage
    exit 1
fi
shift

if [ -n "${PUFFERLIB_DIR:-}" ]; then
    pufferlib_dir="$PUFFERLIB_DIR"
elif [ -d /puffertank/pufferlib ]; then
    pufferlib_dir=/puffertank/pufferlib
elif [ -d "$(dirname "${BASH_SOURCE[0]}")/pufferlib" ]; then
    pufferlib_dir="$(dirname "${BASH_SOURCE[0]}")/pufferlib"
else
    echo "PufferLib checkout not found. Set PUFFERLIB_DIR or run install.sh first." >&2
    exit 1
fi

cd "$pufferlib_dir"

forest_args=(
    --env.num-drones=1
    --env.race-frac=0
    --env.sphere-frac=0
    --env.cube-frac=0
    --env.flag-frac=0
    --env.forest-frac=1
)

case "$mode" in
    build)
        ./build.sh drone
        ;;
    train)
        ./build.sh drone
        puffer train drone --env.hover-frac=0.25 "${forest_args[@]}" "$@"
        ;;
    eval)
        ./build.sh drone
        puffer eval drone --env.hover-frac=0 "${forest_args[@]}" "$@"
        ;;
    *)
        usage
        exit 1
        ;;
esac
