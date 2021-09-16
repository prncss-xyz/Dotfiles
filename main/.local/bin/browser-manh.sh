#!/usr/bin/env sh
mkdir -p $HOME/.tmp
cp $1 $HOME/.tmp/browser.html 
browser $HOME/.tmp/browser.html &
