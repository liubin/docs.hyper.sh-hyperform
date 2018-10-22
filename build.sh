#!/bin/bash

echo "> ensure gitbook-cli was installed"
gitbook --version 2>/dev/null || npm install gitbook-cli -g

echo "> ensure gitbook-summary was installed"
book sm --version 2>/dev/null || npm install -g liubin/gitbook-summary

echo "> delete old SUMMARY.md and _book/"
rm -rf SUMMARY.md _book dist/hyperform 2>/dev/null

echo "> install npm plugins"
npm install


echo "> generate new SUMMARY.md"
book sm

echo "> gitbook build"
RLT=$(gitbook build | grep "Error: Couldn't locate plugins" | wc -l)
if [ $RLT -ne 0 ];then
  echo "found new plugin(s)"
  echo "> install gitbook plugins"
  gitbook install
  echo "> gitbook build again"
  gitbook build
fi

echo "Done"
