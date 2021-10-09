#!/bin/bash

TMP_DIR_PATH="./tmp"

rm -rf $TMP_DIR_PATH

mkdir -p $TMP_DIR_PATH/test1/test1_sub1
touch $TMP_DIR_PATH/test1/apple.js
touch $TMP_DIR_PATH/test1/test1_sub1/test1_sub1_apple.ts
