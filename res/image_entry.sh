#!/bin/bash

export MTOOLSRC=$1
DIR_BIN=$2
ARCH=$3

echo "GRUBADD  kernel_$ARCH"
echo >> $DIR_BIN/boot/grub/menu.lst
echo "title niwohlos3, $ARCH" >> $DIR_BIN/boot/grub/menu.lst
echo -e "\troot (fd0)" >> $DIR_BIN/boot/grub/menu.lst
echo -e "\tkernel /kernel_$ARCH" >> $DIR_BIN/boot/grub/menu.lst
echo -e "\tboot" >> $DIR_BIN/boot/grub/menu.lst
mcopy $DIR_BIN/kernel_$ARCH x:/kernel_$ARCH
