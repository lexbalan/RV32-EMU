
INDIR=./src
OUTDIR=./out

.PHONY: all C LLVM CM clean

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/

CM_OPTS = -funsafe

C_OPTIONS = -I$(CPREFIX) -I$(CPREFIX)/hart



all: LLVM


LLVM:
	mcc -o $(LLVMPREFIX)/main $(CM_OPTS) -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/hart/hart $(CM_OPTS) -mbackend=llvm $(INDIR)/hart/hart.m
	mcc -o $(LLVMPREFIX)/hart/decode $(CM_OPTS) -mbackend=llvm $(INDIR)/hart/decode.m
	mcc -o $(LLVMPREFIX)/bus $(CM_OPTS) -mbackend=llvm $(INDIR)/bus.m
	mcc -o $(LLVMPREFIX)/mmio $(CM_OPTS) -mbackend=llvm $(INDIR)/mmio.m
	clang \
		$(LLVMPREFIX)/main.ll \
		$(LLVMPREFIX)/hart/hart.ll \
		$(LLVMPREFIX)/hart/decode.ll \
		$(LLVMPREFIX)/bus.ll \
		$(LLVMPREFIX)/mmio.ll


CM:
	mcc -o $(CMPREFIX)/main $(CM_OPTS) -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/hart/hart $(CM_OPTS) -mbackend=cm $(INDIR)/hart/hart.m
	mcc -o $(CMPREFIX)/hart/decode $(CM_OPTS) -mbackend=cm $(INDIR)/hart/decode.m
	mcc -o $(CMPREFIX)/hart/csr $(CM_OPTS) -mbackend=cm $(INDIR)/hart/csr.m
	mcc -o $(CMPREFIX)/bus $(CM_OPTS) -mbackend=cm $(INDIR)/bus.m
	mcc -o $(CMPREFIX)/mmio $(CM_OPTS) -mbackend=cm $(INDIR)/mmio.m


C:
	mcc -o $(CPREFIX)/main $(CM_OPTS) -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/hart/hart $(CM_OPTS) -mbackend=c $(CM_OPTS) $(INDIR)/hart/hart.m
	mcc -o $(CPREFIX)/hart/csr $(CM_OPTS) $(COPTIONS) -mbackend=c $(INDIR)/hart/csr.m
	mcc -o $(CPREFIX)/hart/decode $(CM_OPTS) -mbackend=c $(CM_OPTS) $(INDIR)/hart/decode.m
	mcc -o $(CPREFIX)/bus $(CM_OPTS) $(CM_OPTS) -mbackend=c $(INDIR)/bus.m
	mcc -o $(CPREFIX)/mmio $(CM_OPTS) $(CM_OPTS) -mbackend=c $(INDIR)/mmio.m
	CC $(C_OPTIONS) \
		$(CPREFIX)/main.c \
		$(CPREFIX)/hart/hart.c \
		$(CPREFIX)/hart/decode.c \
		$(CPREFIX)/bus.c \
		$(CPREFIX)/mmio.c


clean:
	rm *.o

