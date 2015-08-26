#!/bin/bash

# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Mirror one git repo to another.

# Exit this script if one command fails.
set -e

# Print all commands for debug.
set -x

if [ $# -ne 3 ]; then
  echo "Usage: $0 [source git host] [destination git host] [repo name]"
  echo "Example: $0 https://fuchsia.googlesource.com https://github.com/effenel fnl-start"
  exit 1
fi

srcHost=$1; dstHost=$2; repoName=$3
tempDir=$(mktemp -d fnl-gitsync.XXX)

# Make sure we clean up our temp directory no matter what.
tempDirAbs=$(cd $tempDir && pwd)
trap "rm -rf $tempDirAbs" INT TERM EXIT

# Pull down the source host.
cd $tempDir
git clone --mirror $srcHost/$repoName $repoName

# Add a git remote to the destination host.
cd $repoName
cat >>config <<EOF
[remote "gitsync"]
  url = $dstHost/$repoName
EOF

# Push to the destination.
git push --mirror gitsync
