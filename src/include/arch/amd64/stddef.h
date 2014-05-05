/******************************************************************************
 * Copyright (c) 2011 Max Reitz                                               *
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
 *****************************************************************************/
#ifndef _STDDEF_H
#define _STDDEF_H

#include "stdint.h"

#ifndef NULL
#define NULL ((void *)0)
#endif

typedef uint64_t size_t;
typedef int64_t ssize_t;

#endif

