#!/usr/bin/env bash

hf=$(pwd)/../hyperform

mkdir -p ${hf}/docs/reference/gen

rm -rf ${hf}/docs/reference/gen/*

set -eu -o pipefail

go build -o /tmp/md-docs-generator github.com/hyperhq/hyperform/docs/reference
/tmp/md-docs-generator --root "${hf}" --target "${hf}/docs/reference/gen"

mv ${hf}/docs/reference/gen/hf.md ${hf}/docs/reference/gen/README.md

echo "> copy cli docs"

rm -rf 03-Reference/CLI/*
cp -r ${hf}/docs/reference/gen/* 03-Reference/CLI/


echo "> generate new SUMMARY.md"
book sm

echo "> gitbook build"
gitbook build

echo "OK"
