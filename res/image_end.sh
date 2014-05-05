#!/bin/bash

export MTOOLSRC=$1
DIR_BIN=$2

mcopy -s $DIR_BIN/boot/grub/menu.lst x:/boot/grub/menu.lst
rm $MTOOLSRC
