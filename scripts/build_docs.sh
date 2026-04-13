#!/usr/bin/env bash
# Build Sphinx HTML for one or all ROS 2 distributions. Each distro uses the
# matching *.repos file (branch pins per subrepository) and writes to
# _build/html/<distro>/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SUBREPOS=(
  doc/ur_client_library
  doc/ur_description
  doc/ur_robot_driver
  doc/ur_simulation_gz
  doc/ur_tutorials
)

DISTROS=(jazzy kilted rolling)
REDIRECT_TARGET="${DOCUMENTATION_ROOT_REDIRECT:-rolling}"

# Relative URL from _build/html/<relpath> to _build/html/<target>/<relpath>
redirect_url_to_versioned() {
  local versionless_relpath="$1"
  local target="$2"
  local dir
  dir="$(dirname "$versionless_relpath")"
  local up=""
  while [[ "$dir" != "." ]]; do
    up="../${up}"
    dir="$(dirname "$dir")"
  done
  printf '%s' "${up}${target}/${versionless_relpath}"
}

clean_subrepos() {
  rm -rf "${SUBREPOS[@]}"
}

build_one() {
  local distro="$1"
  export ROS_DISTRO="$distro"
  echo -e "\n\n====== Building documentation for ROS 2 distro: ${distro} ======\n"
  clean_subrepos
  vcs import --input "${distro}.repos" doc
  sphinx-build -b html . "${ROOT}/_build/html/${distro}"
}

# Place a version-less HTML stub for each page in <target>/ so that
# /path/to/page.html redirects to /<target>/path/to/page.html (GitHub Pages).
write_versionless_redirects() {
  local target="$1"
  local src="${ROOT}/_build/html/${target}"
  if [[ ! -d "$src" ]]; then
    echo "write_versionless_redirects: missing ${src}" >&2
    return 1
  fi
  while IFS= read -r -d '' f; do
    local relpath="${f#"${src}/"}"
    local dest="${ROOT}/_build/html/${relpath}"
    mkdir -p "$(dirname "$dest")"
    local url
    url="$(redirect_url_to_versioned "$relpath" "$target")"
    cat > "$dest" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=${url}">
  <link rel="canonical" href="${url}">
  <title>Universal Robots ROS 2 Driver Documentation</title>
</head>
<body>
  <p><a href="${url}">Continue to ${target} documentation</a>.</p>
</body>
</html>
EOF
  done < <(find "$src" -name '*.html' -print0)
}

if [[ $# -eq 0 ]]; then
  for d in "${DISTROS[@]}"; do
    build_one "$d"
  done
  write_versionless_redirects "$REDIRECT_TARGET"
else
  for d in "$@"; do
    build_one "$d"
  done
fi
