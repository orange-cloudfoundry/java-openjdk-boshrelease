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

set -e
OUTPUT="$PWD/bosh-release-candidate"
VERSION="$(cat boshrelease-version/version)"
OPENJDK_DIR="$PWD/openjdk"

echo "DEBUG - OUTPUT: <$OUTPUT> - VERSION: <$VERSION>"

pushd java-open-boshrelease
  git config user.name "$GH_USER"
  git config user.email "$GH_USER_EMAIL"
  git config credential.helper "store --file=.git/credentials"
  echo "https://$GH_TOKEN:@github.com" > .git/credentials
  git config --global push.default simple

  echo "Create release candidate branch"
  git checkout -b release-candidate/${VERSION}

  git status

#  echo "Sync blobs"
#  bosh sync blobs

  echo "Getting OpenJDK blobs"
  bosh add blob ${OPENJDK_DIR}/openjdk.tar.gz openjdk


  echo "Creating bosh release"
  bosh -n create release --with-tarball --name java-openjdk-boshrelease --version "$VERSION"

  echo "Moving to $OUTPUT"
  mv dev_releases/java-openjdk-boshrelease/java-openjdk-boshrelease-*.tgz "$OUTPUT"

  git status

popd
