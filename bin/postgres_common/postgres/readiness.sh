#!/bin/bash

# Copyright 2016 - 2022 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

RADONDB_DIR=${RADONDB_DIR:-'/opt/radondb'}
source "${RADONDB_DIR}/bin/common_lib.sh"
enable_debugging
source "${RADONDB_DIR}/bin/postgres/setenv.sh"

$PGROOT/bin/psql -f "${RADONDB_DIR}/bin/postgres/readiness.sql" -U $PG_USER --port="${PG_PRIMARY_PORT}" postgres
