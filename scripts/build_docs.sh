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

write_root_redirect() {
  local target="$1"
  cat > "${ROOT}/_build/html/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=${target}/index.html">
  <link rel="canonical" href="${target}/index.html">
  <title>Universal Robots ROS 2 Driver Documentation</title>
</head>
<body>
  <p><a href="${target}/index.html">Continue to ${target} documentation</a>.</p>
</body>
</html>
EOF
}

if [[ $# -eq 0 ]]; then
  for d in "${DISTROS[@]}"; do
    build_one "$d"
  done
  write_root_redirect "$REDIRECT_TARGET"
else
  for d in "$@"; do
    build_one "$d"
  done
fi
