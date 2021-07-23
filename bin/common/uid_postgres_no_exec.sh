#!/bin/bash

# Copyright 2019 - 2021 Qingcloud Data Solutions, Inc.
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

QiNGCLOUD_DIR=${QiNGCLOUD_DIR:-'/opt/qingcloud'}
    
export QiNGCLOUD_NSS_USERNAME="${USER_NAME:-postgres}"
export QiNGCLOUD_NSS_USER_DESC="PostgreSQL Server"
    
source "${QiNGCLOUD_DIR}/bin/nss_wrapper.sh"
