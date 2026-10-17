#!/bin/bash
# maintainer script; pushes tags
# Tags a Lumen release only after everything that could make it a bad one has passed: the API check
# against the previous release (with the changelog owning up to any break), a strict build, and the
# whole test suite with goldens. Then it tags and pushes.
#
#   Scripts/release.sh 0.12.0
set -euo pipefail
cd "$(dirname "$0")/.."
version="${1:?usage: Scripts/release.sh <version>}"
tag="v$version"
scratch="${LUMEN_SCRATCH:-${TMPDIR:-/tmp}/lumen-release}"
git diff --quiet && git diff --cached --quiet || { echo "error: commit your changes first" >&2; exit 1; }
# An untracked file the build can see (a source, a resource, a golden) would be tested but not tagged.
untracked=$(git ls-files --others --exclude-standard -- Package.swift Package.resolved Sources Tests Examples Scripts)
[[ -z "$untracked" ]] || { printf 'error: untracked files the build or tests would use; commit or remove them:\n%s\n' "$untracked" >&2; exit 1; }
# The release gate compares goldens whatever the caller's shell says.
[[ -z "${LUMEN_SKIP_GOLDENS:-}" && -z "${LUMEN_RECORD_SNAPSHOTS:-}" && -z "${LUMEN_GOLDENS_DIR:-}" ]] \
  || { echo "error: unset LUMEN_SKIP_GOLDENS, LUMEN_RECORD_SNAPSHOTS and LUMEN_GOLDENS_DIR; a release compares every golden" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$tag" >/dev/null && { echo "error: $tag already exists" >&2; exit 1; }
grep -q "^## $version " CHANGELOG.md || { echo "error: CHANGELOG.md has no '## $version' entry" >&2; exit 1; }
previous=$(git describe --tags --abbrev=0)
echo "== API check against $previous"
Scripts/api-check.sh "$previous"
echo "== Strict build"
swift build --scratch-path "$scratch" --build-tests -Xswiftc -warnings-as-errors
echo "== Tests (goldens included)"
swift test --scratch-path "$scratch" --skip-build
echo "== Tagging $tag"
git tag -a "$tag" -m "Lumen $version"
git push --quiet origin HEAD --follow-tags
echo "Released $tag ($(git rev-parse --short HEAD))"
