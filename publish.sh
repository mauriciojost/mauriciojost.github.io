#!/bin/bash

set -x
set -e

curr_dir="$(readlink -e `dirname $0`)"
root_dir="$curr_dir"
site_dir="$root_dir/_site"
site_dir="$root_dir/_site"
site_tgz_tmp="/tmp/publish-$RANDOM-$RANDOM.tar.gz"
date_now="$(date)"

git checkout development
rm -fr "$site_dir"
mkdir -p "$site_dir"
cp 
jekyll build

ls -lah "$site_dir"
cd "$site_dir"
tar -czf "$site_tgz_tmp" *
cd "$root_dir"
rm -fr "$site_dir"

git checkout master
cd "$root_dir"
rm -fr *
tar -xf "$site_tgz_tmp"
git commit -a -s -m "Publish site as of $date_now"
git push -f origin master

git checkout -f development

