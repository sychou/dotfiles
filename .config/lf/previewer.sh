#!/bin/bash

case "$1" in
    *.tar*) tar tf "$1" ;;
    *.zip)  unzip -l "$1" ;;
    *.pdf)  pdftotext "$1" - ;;
    *)      bat --color=always --style=plain --paging=never "$1" ;;
esac
