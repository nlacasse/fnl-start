#!/bin/bash
#
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
