#!smake
# $Id$
#
# ６４ゼルダ用メイクファイル
# マップデータ作成用
#
# $Log$
#

.NOTPARALLEL:				# 並列動作を禁止

MAKEOPTION = 
#ifdef VMAKEOPT
MAKEOPTION += "VMAKEOPT=$(VMAKEOPT)"
#endif

include $(ROOT)/usr/include/make/PRdefs
include $(ROOT)/usr/local/srd/PR/SRDdefs.mk
include $(COMMONRULES)

SHELL = /bin/sh

#
# ディレクトリの設定
#

ZELDA_LIB =	$(ZELDA_ROOT)/lib
ZELDA_DATA =	$(ZELDA_ROOT)/data
ZELDA_SRC =	$(ZELDA_ROOT)/src

LCINCS = \
-I$(ZELDA_SRC) \
-I$(ZELDA_LIB) \
-I$(PATCH_INCDIR) -I$(PATCH_INCDIR)/.. \
-I$(COMMON_INCDIR) -I$(ROOT)/usr/include/PR
LLDOPTS = \
$(MKDEPOPT)

LMAKEOPT =
LMAKEOPT +=	-DF3DEX_GBI 			# 開発３部のマイクロコードを使用する

#ifdef FINAL_ROM
ROM_VERSION=
OPTIMIZER = 	-O3 -g0				# 速く・小さく
LMAKEOPT +=	-DDEBUG=0			# put8x8用
#else
OPTIMIZER = 	-O2 -g3				# 普通にオプティマイズ、デバッガ使う
#ifdef ROM_VERSION
LMAKEOPT +=	-DROM_VERSION=1			# 実機用ＲＯＭの作成
#else
LMAKEOPT +=	-DROM_VERSION=0			# エミュレータボード用
#endif
LMAKEOPT +=	-DDEBUG=1			# put8x8用
#endif

LWOFF = 	,828,852,813,827

MAKEOPT = $(GMAKEOPT) $(LMAKEOPT) $(VMAKEOPT)

#LCINCS =
LCDEFS += $(MAKEOPT)
LCOPTS = -non_shared -G 0 -mips2 -fullwarn -float -xansi -Xcpluscomm -wlint,-fhp


XXX = xxx
GT = gt
## make clean で消えるもの
LDIRT  =  $(XXX)_vtx.c
TARGETS = $(XXX)x1.o

#
# エントリ登録
#
default:	$(TARGETS)

$(XXX)_s.o:$(XXX)_s.c
$(XXX)_s.c:$(XXX).c
	square $(XXX).c > $(XXX)_s.c
$(XXX)_c.c:$(XXX).c
	-rm -f $(XXX)_c.c
	ln -s $(XXX).c $(XXX)_c.c
$(XXX)_info.o:$(XXX)_info.c
$(XXX)_vtx.o:$(XXX)_vtx.c
$(XXX)_vtx.c:$(XXX)_c.c
	-$(GT) $(XXX)_c.c > $(XXX)_vtx.c
$(XXX)x1.o $(XXX).map: $(XXX)_s.o $(XXX)_info.o $(XXX)_vtx.o
	$(LD) -wall -r $(XXX)_s.o $(XXX)_info.o $(XXX)_vtx.o -o $(XXX)x1.o -m > $(XXX)x1.map
