ARCH = $(shell uname -m)
DIR_CWD = $(shell pwd)

ifeq ($(ARCH),x86_64)
ARCHFLAGS = $(ARCHFLAGS_AMD64)
ARCH = $(ARCH_AMD64)
else ifeq ($(ARCH),x86)
ARCHFLAGS = $(ARCHFLAGS_I386)
ARCH = $(ARCH_I386)
else ifeq ($(ARCH),i686)
ARCHFLAGS = $(ARCHFLAGS_I386)
ARCH = $(ARCH_I386)
else
ARCHFLAGS = $(ARCHFLAGS_I386)
ARCH = $(ARCH_I386)
endif

DIR_OBJ = $(DIR_CWD)/obj
DIR_SRC = $(DIR_CWD)/src
DIR_BIN = $(DIR_CWD)/bin
DIR_INC = $(DIR_SRC)/include
DIR_RES = $(DIR_CWD)/res
DIR_EXT = $(DIR_OBJ)/ext

TAR_KER = $(DIR_BIN)/kernel

MAKE = make -s
CC = gcc
LD = ld
ASM = gcc
SH = bash
AR = ar

LDFLAGS = -n
CFLAGS = -g -g3 -Wall -Wextra -std=gnu1x -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -fno-leading-underscore -O0

ARCHFLAGS_AMD64 = -m64
ARCHFLAGS_I386 = -m32
ARCH_AMD64 = amd64
ARCH_I386 = i386

.PHONY: all amd64 i386 i386-extract clean clean-for-real clean-deep clean-deep-for-real image-begin image-entry image-end version dirs tools test todo fixme lines

all: dirs clean-deep tools
	@echo '-------- Building niwohlos3'
	@$(MAKE) version
	@$(MAKE) image-begin
	@$(MAKE) "ARCH=$(ARCH)" "ARCHFLAGS=$(ARCHFLAGS)" $(ARCH)
	@$(MAKE) image-end

amd64: dirs clean
	@echo '-------- Architecture amd64'
	@$(MAKE) "ARCH=$(ARCH_AMD64)" "ARCHFLAGS=$(ARCHFLAGS_AMD64)" $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ)/%_c.o,$(patsubst $(DIR_SRC)/%.S,$(DIR_OBJ)/%_S.o,$(sort $(shell find $(DIR_SRC)/kernel \( -iregex ".*\.c" -or -iregex ".*\.S" \) -and -not -iregex "$(DIR_SRC)/kernel/arch/.*" -and -not -iregex "(DIR_SRC)/kernel/drivers/.*")) $(sort $(shell find $(DIR_SRC)/kernel/arch/$(ARCH_AMD64) -iregex ".*\.c" -or -iregex ".*\.S")) $(sort $(shell find $(DIR_SRC)/kernel/drivers/$(ARCH) -iregex ".*\.c" -or -iregex ".*\.S"))))
	@$(MAKE) "ARCH=$(ARCH_AMD64)" "ARCHFLAGS=$(ARCHFLAGS_AMD64)" $(TAR_KER)
	@$(MAKE) "ARCH=$(ARCH_AMD64)" image-entry
	@$(MAKE) "ARCH=$(ARCH_I386)" "ARCHFLAGS=$(ARCHFLAGS_I368)" i386

i386: dirs clean
	@echo '-------- Architecture i386'
	@$(MAKE) "ARCH=$(ARCH_I386)" "ARCHFLAGS=$(ARCHFLAGS_I386)" $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ)/%_c.o,$(patsubst $(DIR_SRC)/%.S,$(DIR_OBJ)/%_S.o,$(sort $(shell find $(DIR_SRC)/kernel \( -iregex ".*\.c" -or -iregex ".*\.S" \) -and -not -iregex "$(DIR_SRC)/kernel/arch/.*" -and -not -iregex "$(DIR_SRC)/kernel/drivers/.*")) $(sort $(shell find $(DIR_SRC)/kernel/arch/$(ARCH_I386) -iregex ".*\c" -or -iregex ".*\.S")) $(sort $(shell find $(DIR_SRC)/kernel/drivers/$(ARCH) -iregex ".*\.c" -or -iregex ".*\.S"))))
	@$(MAKE) i386-extract
	@$(MAKE) "ARCH=$(ARCH_I386)" "ARCHFLAGS=$(ARCHFLAGS_I386)" $(TAR_KER)
	@$(MAKE) "ARCH=$(ARCH_I386)" image-entry

i386-extract: $(shell $(CC) $(ARCHFLAGS_I386) --print-libgcc-file-name) dirs
	@$(AR) -x $$($(CC) $(ARCHFLAGS_I386) --print-libgcc-file-name) _umoddi3.o _udivdi3.o
	@mv _umoddi3.o _udivdi3.o $(DIR_EXT)

tools: dirs
	@echo '-------- Tools'

$(DIR_BIN)/tools/%: $(DIR_SRC)/tools/%.c
	@mkdir -p $(dir $@)
	@echo 'CC       $(patsubst $(DIR_BIN)/%,%,$@)'
	@$(CC) -o $@ $^

$(TAR_KER): $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ)/%_c.o,$(patsubst $(DIR_SRC)/%.S,$(DIR_OBJ)/%_S.o,$(shell find $(DIR_SRC)/kernel \( -iregex ".*\.c" -or -iregex ".*\.S" \) -and -not -iregex "$(DIR_SRC)/kernel/arch/.*" -and -not -iregex "$(DIR_SRC)/kernel/drivers/.*") $(shell find $(DIR_SRC)/kernel/arch/$(ARCH) -iregex ".*\.c" -or -iregex ".*\.S") $(shell find $(DIR_SRC)/kernel/drivers/$(ARCH) -iregex ".*\.c" -or -iregex ".*\.S" ))) $(shell find $(DIR_EXT) -type f 2> /dev/null)
	@mkdir -p $(dir $@)
	@echo 'CC       $(patsubst $(DIR_BIN)/%,%,$@_$(ARCH))'
	@$(LD) $(LDFLAGS) -o $@_$(ARCH) $^ -T$(DIR_SRC)/kernel/link/$(ARCH).ld

$(DIR_OBJ)/kernel/%_c.o: $(DIR_SRC)/kernel/%.c
	@mkdir -p $(dir $@)
	@echo 'CC       $(patsubst $(DIR_BIN)/%,%,$@_$(ARCH))'
	@$(CC) -c $(CFLAGS) $(ARCHFLAGS) -I$(DIR_INC)/arch/$(ARCH) -I$(DIR_INC) -o $@ $<

$(DIR_OBJ)/kernel/%_S.o: $(DIR_SRC)/kernel/%.S
	@mkdir -p $(dir $@)
	@echo 'ASM      $(patsubst $(DIR_SRC)/%,%,$<)'
	@$(CC) -c $(CFLAGS) $(ARCHFLAGS) -o $@ $<

clean:
	@echo '-------- Cleaning'
	@$(MAKE) clean-for-real

clean-for-real:
	@-echo "RM       Deleted $$(rm -Rv $(DIR_OBJ)/* 2> /dev/null | wc -l) files"

clean-deep:
	@echo '-------- Cleaning deeply'
	@$(MAKE) clean-deep-for-real

clean-deep-for-real:
	@-echo "RM       Deleted $$(rm -Rv $(DIR_BIN)/* 2> /dev/null | wc -l) files"

image-begin:
	@echo '-------- Floppy image'
	@$(DIR_RES)/image_begin.sh $(DIR_RES)/niwohlos.cfg $(DIR_BIN) $(DIR_RES)
	@echo 'MOUNT    Mounted floppy image'

image-end:
	@echo '------ Floppy image'
	@$(DIR_RES)/image_end.sh $(DIR_RES)/niwohlos.cfg $(DIR_BIN)
	@echo 'UNMOUNT  Unmounted floppy image'

image-entry:
	@echo '-------- Floppy iamge'
	@$(DIR_RES)/image_entry.sh $(DIR_RES)/niwohlos.cfg $(DIR_BIN) $(ARCH)

version:
	@echo '-------- Version information'
	@$(shell $(SH) version.sh)
	@echo 'VERSION  Updated version information'

dirs:
	@mkdir -p $(DIR_BIN)
	@mkdir -p $(DIR_SRC)
	@mkdir -p $(DIR_INC)
	@mkdir -p $(DIR_OBJ)
	@mkdir -p $(DIR_RES)
	@mkdir -p $(DIR_EXT)

test:
	@bochs -f niwohlos.cfg -q

todo:
	@find src -type f -iregex "^.*\.\(c\|h\|S\)" -exec grep -Hn TODO \{\} \; 2> /dev/null

fixme:
	@find src -type f -iregex "^.*\.\(c\|h\|S\)" -exec grep -Hn FIXME \{\} \; 2> /dev/null

lines:
	@find src -type f -iregex "^.*\.\(c\|h\|S\)" | xargs wc | tail -n 1 2> /dev/null
