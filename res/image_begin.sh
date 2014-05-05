#!/bin/bash

export MTOOLSRC=$1
DIR_BIN=$2
DIR_RES=$3

echo -e "drive x:\nfile=\"$DIR_BIN/floppy.img\" cylinders=80 heads=2 sectors=18 filter" > $MTOOLSRC
cp $DIR_RES/base.img.bz2 $DIR_BIN/floppy.img.bz2
bunzip2 $DIR_BIN/floppy.img.bz2
mkdir -p $DIR_BIN/boot/grub
cp $DIR_RES/menu.lst $DIR_BIN/boot/grub/menu.lst
