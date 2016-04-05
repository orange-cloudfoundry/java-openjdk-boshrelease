#!/usr/bin/env bash
#
# Copyright (C) 2015 Orange
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e -x

if [ -z "$PACKAGE_NAME" ]; then
  echo "must specify \$PACKAGE_NAME" >&2
  exit 1
fi

git config --global user.name "$GH_USER"
git config --global user.email "$GH_USER_EMAIL"

FINAL_RELEASE_REPO=bumped-boshrelease

git clone boshrelease-repo ${FINAL_RELEASE_REPO}
cp bosh-credentials/ci/config/private.yml ${FINAL_RELEASE_REPO}/config/private.yml


cd ${FINAL_RELEASE_REPO}/

bosh -n add blob ../blob-dir/${PACKAGE_NAME}.tar.gz ${PACKAGE_NAME}
bosh -n upload blobs

git add -A
git commit -m "update ${PACKAGE_NAME} blob"
