#!/bin/bash
if [ "$ARCH" == "" ]
then
    ARCH="i386"
fi

if [ "$IMAGE_TYPE" == "" ]
then
    IMAGE_TYPE=default
fi

IMAGE_SCRIPT=$ARCH-$IMAGE_TYPE.sh

alias ls="ls --color=never"

case "$1" in
    all|"")
        target="all"
        ;;
    clean)
        target="clean"
        ;;
    --help|-h|-?)
        echo "Usage: ARCH=<architecture> IMAGE_TYPE=<image type> ./build.sh <target>"
        echo "  architecture: Architecture name to compile for. May be one of:"
        echo "                $(ls src/kernel/arch | tr '\n' ' ')"
        echo "                The default is 'i386'."
        echo "  image type: Type of the image to be created. The available formats are:"
        echo "$(ls build/scripts/*-*.sh | sed -e 's/build\/scripts\/\(.*\)-\(.*\)\.sh/                \1: \2/')"
        echo "              The default is 'default'."
        echo "  target: Operation to be executed. May be either 'all' or 'clean' (default is"
        echo "          'all')."
        exit 0
        ;;
    *)
        echo "No such target '$1'." >&2
        exit 1
        ;;
esac

if [[ "$target" == "all" && ! -x build/scripts/$IMAGE_SCRIPT ]]
then
    echo "No such arch/image type combination $ARCH/$IMAGE_TYPE." >&2
    exit 1
fi

src_subdirs=$(ls src -p | grep / | grep -v include | sed -e 's/\(.*\)\//\1/')

export ARCH
export target

export include_dirs="$(pwd)/src/include $(pwd)/src/include/arch/$ARCH"

for src_subdir in $src_subdirs
do
    if [ "$target" != "clean" ]
    then
        echo "——— $src_subdir ———"
    fi

    pushd src/$src_subdir &> /dev/null
    ./build.sh || exit 1
    popd &> /dev/null
done

mkdir -p build/images build/root/boot

if [ "$target" == "all" ]
then
    echo "——— image ———"
    build/scripts/$IMAGE_SCRIPT || exit 1
else
    rm -rf build/images/* build/root/*
fi
