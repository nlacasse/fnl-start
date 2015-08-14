#!/bin/bash
#
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
