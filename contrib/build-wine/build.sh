#!/bin/bash
#
# env vars:
# - ELECBUILD_NOCACHE: if set, forces rebuild of docker image
# - ELECBUILD_COMMIT: if set, do a fresh clone and git checkout

set -e

# Use portable method to get absolute path (macOS readlink doesn't support -e)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROJECT_ROOT_OR_FRESHCLONE_ROOT="$PROJECT_ROOT"
CONTRIB="$PROJECT_ROOT/contrib"
CONTRIB_WINE="$CONTRIB/build-wine"

. "$CONTRIB"/build_tools_util.sh


DOCKER_BUILD_FLAGS=""
if [ ! -z "$ELECBUILD_NOCACHE" ] ; then
    info "ELECBUILD_NOCACHE is set. forcing rebuild of docker image."
    DOCKER_BUILD_FLAGS="--pull --no-cache"
fi

# Use docker without sudo if available (e.g., in CI), otherwise fall back to sudo
if docker info > /dev/null 2>&1; then
    DOCKER_CMD="docker"
else
    DOCKER_CMD="sudo docker"
fi

info "building docker image."
# Force x86_64 platform - Wine requires x86_64 and won't work on ARM
$DOCKER_CMD build \
    --platform linux/amd64 \
    $DOCKER_BUILD_FLAGS \
    -t electrum-wine-builder-img \
    "$CONTRIB_WINE"

# maybe do fresh clone
if [ ! -z "$ELECBUILD_COMMIT" ] ; then
    info "ELECBUILD_COMMIT=$ELECBUILD_COMMIT. doing fresh clone and git checkout."
    FRESH_CLONE="$CONTRIB_WINE/fresh_clone/electrum" && \
        rm -rf "$FRESH_CLONE" && \
        umask 0022 && \
        git clone "$PROJECT_ROOT" "$FRESH_CLONE" && \
        cd "$FRESH_CLONE"
    git checkout "$ELECBUILD_COMMIT"
    PROJECT_ROOT_OR_FRESHCLONE_ROOT="$FRESH_CLONE"
else
    info "not doing fresh clone."
fi

info "building binary..."
$DOCKER_CMD run -i \
    --platform linux/amd64 \
    --name electrum-wine-builder-cont \
    -v "$PROJECT_ROOT_OR_FRESHCLONE_ROOT":/opt/wine64/drive_c/electrum \
    --rm \
    --workdir /opt/wine64/drive_c/electrum/contrib/build-wine \
    electrum-wine-builder-img \
    ./make_win.sh

# make sure resulting binary location is independent of fresh_clone
if [ ! -z "$ELECBUILD_COMMIT" ] ; then
    mkdir --parents "$PROJECT_ROOT/contrib/build-wine/dist/"
    cp -f "$FRESH_CLONE/contrib/build-wine/dist"/*.exe "$PROJECT_ROOT/contrib/build-wine/dist/"
fi
