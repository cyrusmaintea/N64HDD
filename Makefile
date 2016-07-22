ROOTDIR = $(N64_INST)
GCCN64PREFIX = $(ROOTDIR)/bin/mips64-elf-
CHKSUM64PATH = $(ROOTDIR)/bin/chksum64
MKDFSPATH = $(ROOTDIR)/bin/mkdfs
HEADERPATH = $(ROOTDIR)
N64TOOL = $(ROOTDIR)/bin/n64tool
HEADERNAME = header
LINK_FLAGS = -L$(ROOTDIR)/lib -L$(ROOTDIR)/mips64-elf/lib -ldragon -lc -lm -ldragonsys -Tn64ld_exp_cpp.x
PROG_NAME = N64HD
CFLAGS = -std=gnu99 -march=vr4300 -mtune=vr4300 -O3 -Wall -I$(CURDIR)/include -I$(ROOTDIR)/include -I$(ROOTDIR)/mips64-elf/include
ASFLAGS = -mtune=vr4300 -march=vr4300
CC = $(GCCN64PREFIX)gcc
AS = $(GCCN64PREFIX)as
LD = $(GCCN64PREFIX)ld
OBJCOPY = $(GCCN64PREFIX)objcopy

OBJS = src/hdd64.o src/gfx.o src/cd64.o src/ata.o src/fat16.o src/loader.o src/hdd64_system.o src/header.o src/savedata.o

$(PROG_NAME).v64: $(PROG_NAME).elf
	$(OBJCOPY) $(PROG_NAME).elf $(PROG_NAME).bin -O binary
	rm -f $(PROG_NAME).v64
	$(N64TOOL) -b -l 256K -t "64HD DevoX.Ltd" -h $(HEADERPATH)/$(HEADERNAME) -o $(PROG_NAME).v64 $(PROG_NAME).bin
	$(CHKSUM64PATH) $(PROG_NAME).v64

$(PROG_NAME).elf : $(OBJS)
	$(LD) -o $(PROG_NAME).elf $(OBJS) $(LINK_FLAGS)

all: $(PROG_NAME).v64

clean:
	rm -f *.v64 *.elf *.o *.bin *.dfs src/*.o

rebuild: clean all
