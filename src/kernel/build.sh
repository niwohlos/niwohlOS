#!/bin/bash
function find_dirs
{
    find -name "*.$1" -and "(" -not -path "*/arch/*" -or -path "*/arch/$ARCH/*" ")" -and "(" -not -path "*/drivers/*" -or -path "*/drivers/$ARCH/*" ")" | sed -e "s/\.\/\(.*\)\/.*\.$1/\1/"
}

if ! test -f arch/$ARCH/build.vars
then
    echo "Unknown architecture '$ARCH'." >&2
    exit 1
fi

source arch/$ARCH/build.vars

if [ "$target" == "clean" ]
then
    rm -f obj/* kernel*
    exit
fi

objdir=$(pwd)/obj
subdirs="$(find_dirs c) $(find_dirs asm) $(find_dirs S)"
subdirs="$(echo "$subdirs" | tr ' ' '\n' | sort -u)"

mkdir -p "$objdir"

for subdir in $subdirs
do
    echo "<<< $subdir >>>"
    objprefix=$(echo $subdir | sed -e 's/\//__/g')

    for file in $(ls $subdir/*.{c,asm,S} 2> /dev/null)
    do
        filename=$(echo $file | sed -e "s/$(echo $subdir | sed -e 's/\//\\\//g')\///")
        ext=$(echo $filename | sed -e 's/.*\.\(.*\)/\1/')
        output=$objdir/${objprefix}_$(echo $filename | sed -e 's/\(.*\)\..*/\1/')_$ext.o

        if [[ (!( -f $output )) || ( $(stat --printf=%Y $file) > $(stat --print=%Y $output) ) ]]
        then
            case "$ext" in
                c)
                    echo "CC      $filename"
                    $CC $CFLAGS -c $file -o $output || exit 1
                    ;;
                asm)
                    echo "ASM     $filename"
                    if [ "$ASMQUIET" != "" ]; then
                        $ASM $ASMFLAGS $file $ASM_OUT $output &> /dev/null || exit 1
                    else
                        $ASM $ASMFLAGS $file $ASM_OUT $output || exit 1
                    fi
                    ;;
                S)
                    echo "ASM     $filename"
                    if [ "$ASMQUIET" != "" ]; then
                        $ASM $ASMFLAGS $file $ASM_OUT $output &> /dev/null || exit 1
                    else
                        $ASM $ASMFLAGS $file $ASM_OUT $output || exit 1
                    fi
                    ;;
            esac
        fi
    done
done

echo "<<< . >>>"
echo "LD      >kernel"
$LD $LDFLAGS $objdir/*.o -o kernel $LIBS || exit 1
