#!/bin/bash
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

#set -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export ATC_URL=${ATC_URL:-"http://localhost:8080"}
export fly_target=${fly_target:-concourse}
export pipeline=${pipeline:-java-openjdk}
echo "Concourse API target: ${fly_target}"
echo "Concourse Pipeline: ${pipeline}"

if [ -z ${BOSH_DEPLOYMENT} ]
then
    echo "BOSH_DEPLOYMENT is required"
    exit 1
fi

pushd $DIR
 BOSH_CREDENTIALS_DIR="./../../../${BOSH_DEPLOYMENT}"
 echo "current dir: $(pwd) - Credentials dir : $BOSH_CREDENTIALS_DIR"
 fly -t ${fly_target} set-pipeline -c pipeline.yml -p ${pipeline} --load-vars-from $BOSH_CREDENTIALS_DIR/ci/deploy/credentials-java-openjdk-boshrelease.yml --non-interactive
popd
echo "Done"

#set +x
