#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${PROJECT_DIR}/data"
LOCAL_DATA_DIR="${PROJECT_DIR}/local_data"
GENERATOR_IMAGE="zubkov-data-generator"
REPORTER_IMAGE="zubkov-data-reporter"

mkdir -p "${DATA_DIR}" "${LOCAL_DATA_DIR}"

case "${1:-help}" in
  build_generator)
    docker build -t "${GENERATOR_IMAGE}" "${PROJECT_DIR}/generator"
    ;;
  run_generator)
    docker run --rm -v "${DATA_DIR}:/data" "${GENERATOR_IMAGE}"
    ;;
  create_local_data)
    python3 "${PROJECT_DIR}/generator/generate.py" "${LOCAL_DATA_DIR}"
    ;;
  build_reporter)
    docker build -t "${REPORTER_IMAGE}" "${PROJECT_DIR}/reporter"
    ;;
  run_reporter)
    docker run --rm -v "${DATA_DIR}:/data" "${REPORTER_IMAGE}"
    ;;
  structure)
    (
      cd "${PROJECT_DIR}"
      find . -path './.git' -prune -o -print | sort
    )
    ;;
  clear_data)
    find "${DATA_DIR}" -maxdepth 1 -type f \( -name '*.csv' -o -name '*.html' \) -delete
    ;;
  inside_generator)
    docker run --rm -v "${DATA_DIR}:/data" "${GENERATOR_IMAGE}" \
      sh -c 'ls -la /data'
    ;;
  inside_reporter)
    docker run --rm -v "${DATA_DIR}:/data" "${REPORTER_IMAGE}" \
      sh -c 'ls -la /data'
    ;;
  *)
    cat <<'EOF'
Использование: ./run.sh КОМАНДА

Команды:
  build_generator    собрать образ генератора
  run_generator      создать data/data.csv в контейнере
  create_local_data  создать local_data/data.csv без Docker
  build_reporter     собрать образ аналитика
  run_reporter       создать data/report.html в контейнере
  structure          показать структуру проекта
  clear_data         удалить CSV и HTML из data/
  inside_generator   показать data/ внутри генератора
  inside_reporter    показать data/ внутри аналитика
EOF
    exit 1
    ;;
esac
