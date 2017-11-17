#!/bin/sh

set -e

DIR=$(dirname "$0")

ruby ${DIR}/render.rb

cd ${DIR}/..
git add index.html
git commit -m 'generate new index page'
git push -f origin master
