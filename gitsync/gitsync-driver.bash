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

# Fetch the list of Fuchsia repos to sync and run a gitsync.bash for each.
# Designed to be run unattended via cron job.

sourceHost=https://fuchsia.googlesource.com
destHost=https://github.com/effenel
scriptDir=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd)
logDir=$scriptDir/log/$(date +%Y)/$(date +%m)/$(date +%d)
logFile=$logDir/$(date +%H%M%S).log

cd $scriptDir
mkdir -p $logDir

# Everything below the next line will be logged to $logFile.
exec 1>$logFile 2>&1
set -x
echo "[gitsync] Start log"

# Sync fnl-start to pull down the latest list of repos.
git pull

# We keep a list of repos checked in.  We could maybe use GitHub APIs instead.
repoList=$(cat $scriptDir/list-of-repos.txt)
for repo in $repoList; do
  echo "[gitsync] Syncing ${repo}..."
  $scriptDir/gitsync.bash $sourceHost $destHost $repo
  date +%H:%M:%S
done

echo "[gitsync] Exited normally"
