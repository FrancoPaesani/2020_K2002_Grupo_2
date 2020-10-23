FILE_EXT:=exe
LIBS+=-L "C:\FlexyBison\lib"
SRCDIR:=src
IDIR:=src
ODIR:=obj

# Agregar bibliotecas necesarias acá (por ejemplo, -lm para incluir <math.h>)
LIBS+=-lfl -ly -lm

CC:=gcc
CFLAGS+=-I$(IDIR)
BFLAGS+=-v -d
FFLAGS+=

SRC:= $(wildcard $(SRCDIR)/*.l)
DEPS:= $(wildcard $(IDIR)/*.h) $(wildcard $(SRCDIR)/*.c)

TARGETS:=$(patsubst $(SRCDIR)/%.l,%.$(FILE_EXT),$(SRC))

%.$(FILE_EXT): $(SRCDIR)/%.l $(SRCDIR)/%.y $(DEPS)
	@echo "=================[ Build | $@ ]================="
	@echo "<<< Generando $(subst .l,.tab.c,$<) y .h >>>"
	mkdir -p $(ODIR) && cd $(ODIR) && bison $(BFLAGS) ../$(word 2,$^) && cd ..
	@echo "<<< $(subst .l,.tab.c,$<) y .h creados. >>>"
	@echo ""
	@echo "<<< Generando lex.yy.c >>>"
	cd $(ODIR) && flex $(FFLAGS) ../$< && cd ..
	@echo "<<< lex.yy.c creado. >>>"
	@echo ""
	@echo "<<< Compilando y enlazando con libfl.a y liby.a >>>"
	$(CC) $(CFLAGS) $(patsubst $(SRCDIR)/%.l,$(ODIR)/%.tab.c,$<) $(patsubst $(SRCDIR)/%.l,$(ODIR)/%.tab.h,$<) $(ODIR)/lex.yy.c $(SRCDIR)/utiles.c $(SRCDIR)/utiles.h $(LIBS) -o $@ 
	@echo "<<< $@ creado. >>>"
	@echo ""

all: clean $(TARGETS)

.PHONY: clean debug

clean:
	if exist "./obj/" (rd obj /s /q) & if exist "./-p/" (rd -p /s /q)

clear:
	cls

debug: CFLAGS += -DBISON_DEBUG
debug: BFLAGS += --debug
debug: FFLAGS += -d
debug: $(TARGETS)