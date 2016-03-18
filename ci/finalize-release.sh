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

FINAL_RELEASE_TARBALL=$PWD/bosh-final-release-tarball
FINAL_RELEASE_REPO=$PWD/final-release-repo

CANDIDATE_DIR=$PWD/bosh-release-candidate


VERSION="$(cat boshrelease-version/version)"
RELEASE_CANDIDATE_BRANCH="release-candidate/${VERSION}"

if [ -z "$VERSION" ]; then
  echo "missing version number"
  exit 1
fi

git clone ./java-openjdk-boshrelease $FINAL_RELEASE_REPO

cp bosh-credentials/ci/config/private.yml $FINAL_RELEASE_REPO/config/private.yml

pushd $FINAL_RELEASE_REPO
    echo "Checkout branch $RELEASE_CANDIDATE_BRANCH"

    git checkout -b $RELEASE_CANDIDATE_BRANCH
    git config --global user.name "$GH_USER"
    git config --global user.email "$GH_USER_EMAIL"

    RELEASE_TGZ=$PWD/releases/java-openjdk-boshrelease/java-openjdk-boshrelease-${VERSION}.tgz

    echo "finalizing release"
    bosh -n finalize release --version "$VERSION" ${CANDIDATE_DIR}/java-openjdk-boshrelease-*.tgz
    git add -A
    git commit -m "release v${VERSION}"
popd

echo "Moving ${RELEASE_TGZ} to ${FINAL_RELEASE_TARBALL}"
mv ${RELEASE_TGZ} ${FINAL_RELEASE_TARBALL}