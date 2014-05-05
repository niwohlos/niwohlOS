#!/bin/bash

let version=$(tail -n 9 src/include/version.h | head -n 1 | cut -f 3 -d' ')+1
branch=$(git branch | grep \* | sed s/\*\ //g)

cat << EOF > src/include/version.h
/******************************************************************************
 * Copyright (c) 2011 Patrick Pokatilo                                        *
 *                                                                            *
 * This program is free software; you can redistribute it and/or modify it    *
 * under the terms of the GNU General Public License as published by the      *
 * Free Software Foundation; either version 2, or (at your option) any        *
 * later version.                                                             *
 *                                                                            *
 * This program is distributed in the hope that it will be useful,            *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 * GNU General Public License for more details.                               *
 *                                                                            *
 * You should have received a copy of the GNU General Public License          *
 * along with this program; if not, write to the Free Software                *
 * Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.                        *
 ******************************************************************************/

#ifndef _VERSION_H_
#define _VERSION_H_

EOF

echo "#define __BUILD__ $version" >> src/include/version.h
echo "#define __COMMIT__ $(git rev-list $branch | wc -l)" >> src/include/version.h
echo "#define __HEAD__ \"$(git rev-list $branch | head -n 1)\"" >> src/include/version.h
echo "#define __BRANCH__ \"$branch\"" >> src/include/version.h
echo "#define __CHANGED__ \"$(git log -n 1 | grep Date | sed 's/Date:[\t\ ]*//g')\"" >> src/include/version.h
echo "#define __COMPILED__ \"$(date -R)\"" >> src/include/version.h
echo "#define __TAG__ \"$(git tag | tail -n 1)\"" >> src/include/version.h
echo >> src/include/version.h
echo "#endif" >> src/include/version.h
