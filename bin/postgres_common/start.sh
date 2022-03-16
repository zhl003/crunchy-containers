#!/bin/bash
# Start script for compacted postgres operator image
# Used to run correct start script based on MODE

RADONDB_DIR=${RADONDB_DIR:-'/opt/radondb'}
source "${RADONDB_DIR}/bin/common_lib.sh"
enable_debugging

env_check_err "MODE"

echo_info "Image mode found: ${MODE}"
case $MODE in
    postgres)
      echo_info "Starting in 'postgres' mode"
      exec "${RADONDB_DIR}/bin/postgres/start.sh"
      ;;
    pgdump)
      echo_info "Starting in 'pgdump' mode"
      exec "${RADONDB_DIR}/bin/pgdump/start.sh"
      ;;
    pgrestore)
      echo_info "Starting in 'pgrestore' mode"
      exec "${RADONDB_DIR}/bin/pgrestore/start.sh"
      ;;
    pgbench)
      echo_info "Starting in 'pgbench' mode"
      exec "${RADONDB_DIR}/bin/pgbench/start.sh"
      ;;
    pgbasebackup-restore)
      echo_info "Starting in 'basebackup-restore' mode"
      exec "${RADONDB_DIR}/bin/pgbasebackup_restore/start.sh"
      ;;
    backup)
      echo_info "Starting in 'backup' mode"
      exec "${RADONDB_DIR}/bin/backup/start-backupjob.sh"
      ;;
    sqlrunner)
      echo_info "Starting in 'sqlrunner' mode"
      exec "${RADONDB_DIR}/bin/sqlrunner/start.sh"
      ;;
    *)
      echo_err "Invalid Image Mode; Please set the MODE environment variable to a supported mode"
      exit 1
      ;;
esac
