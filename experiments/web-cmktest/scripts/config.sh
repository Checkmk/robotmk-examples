#!/usr/bin/env bash
set -euo pipefail

TMPFILE=""


main() {
  local site_arg="${1:-${SITE:-}}"
  [[ -z "${site_arg}" ]] && usage

  require_root
  init_paths "${site_arg}"
  validate_inputs
  prompt_overwrite
  prepare_config
  install_config
  install_tests
  cleanup
  trap - EXIT INT TERM
  bake_agent
  install_agent
  run_discovery
  restart_site
}



usage() {
  printf 'Usage: %s <site>\n' "$0" >&2
  exit 1
}

cleanup() {
  if [[ -n "${TMPFILE}" && -f "${TMPFILE}" ]]; then
    rm -f "${TMPFILE}"
  fi
  TMPFILE=""
}

require_root() {
  if [[ ${EUID} -ne 0 ]]; then
    printf 'This script must be run with sudo/root privileges.\n' >&2
    exit 1
  fi
}

init_paths() {
  SITE_NAME="$1"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
  BASE_FILE="${PROJECT_ROOT}/checkmk/final.mk"
  SITE_DIR="${PROJECT_ROOT}/checkmk/${SITE_NAME}"
  DEST_DIR="/omd/sites/${SITE_NAME}/etc/check_mk/conf.d"
  DEST_FILE="${DEST_DIR}/final.mk"
  AGENT_PACKAGE="/omd/sites/${SITE_NAME}/var/check_mk/agents/linux_deb/references/${SITE_NAME}"
}

validate_inputs() {
  if [[ ! -f "${BASE_FILE}" ]]; then
    printf 'Base file not found: %s\n' "${BASE_FILE}" >&2
    exit 1
  fi

  if [[ ! -d "${SITE_DIR}" ]]; then
    printf 'Site source directory missing: %s\n' "${SITE_DIR}" >&2
    exit 1
  fi

  if [[ ! -d "${DEST_DIR}" ]]; then
    printf 'Destination directory missing: %s\n' "${DEST_DIR}" >&2
    exit 1
  fi
}

prompt_overwrite() {
  if [[ -f "${DEST_FILE}" ]]; then
    read -r -p "${DEST_FILE} exists. Overwrite? [y/N] " reply
    case "${reply}" in
      [yY][eE][sS]|[yY])
        ;;
      *)
        printf 'Aborting without changes.\n'
        exit 0
        ;;
    esac
  fi
}

prepare_config() {
  TMPFILE="$(mktemp)"
  trap cleanup EXIT INT TERM

  cat "${BASE_FILE}" >"${TMPFILE}"

  # Gather site-specific Python fragments in a deterministic order.
  local -a py_files=()
  mapfile -t py_files < <(find "${SITE_DIR}" -maxdepth 1 -type f -name '*.py' | sort)
  if [[ ${#py_files[@]} -eq 0 ]]; then
    printf 'No Python files found in %s\n' "${SITE_DIR}" >&2
    exit 1
  fi

  local file
  for file in "${py_files[@]}"; do
    printf '\n# from %s\n' "${file}" >>"${TMPFILE}"
    cat "${file}" >>"${TMPFILE}"
  done
}

install_config() {
  install -m 0640 "${TMPFILE}" "${DEST_FILE}"
  chown "${SITE_NAME}:${SITE_NAME}" "${DEST_FILE}"
}

install_tests() {
  local src_dir="${PROJECT_ROOT}"
  local dest_dir="/usr/lib/check_mk_agent/robot/web-cmktest"

  if [[ ! -d "${src_dir}" ]]; then
    printf 'Test source directory missing: %s\n' "${src_dir}" >&2
    exit 1
  fi

  install -d -m 0755 "${dest_dir}"

  # Mirror test assets into the agent tree, removing obsolete files.
  rsync -a --delete "${src_dir}/" "${dest_dir}/"
}

bake_agent() {
  su - "${SITE_NAME}" -c "cmk -Avf ${SITE_NAME}"
}

install_agent() {
  if [[ ! -f "${AGENT_PACKAGE}" ]]; then
    printf 'Agent package not found after bake: %s\n' "${AGENT_PACKAGE}" >&2
    exit 1
  fi

  dpkg -i "${AGENT_PACKAGE}"
}

run_discovery() {
  su - "${SITE_NAME}" -c "cmk IIv ${SITE_NAME}"
}

restart_site() {
  omd restart "${SITE_NAME}"
}


main "$@"
