

# El compilador a usar: Gnu C Compiler, Standard 2011 with GNU extensions
CC=gcc -std=gnu11
# La carpeta donde va todo el código
SRC=src
# La carpeta donde van todos los archivos de objeto
OBJ=obj

OPT=-g# No optimiza.
# OPT=-O1# Optimiza un poquito
# OPT=-O2# Optimiza bastante
# OPT=-O3# Optimiza al máximo. Puede ser peor que -O2 según tu código

# Nivel de optimización para las librerías del código base (COMMON)
BASE_OPT=-O2


# -Wunused = (Warn Unused) Da aviso de las variables que no se estan usando
# -Wall    = (Warn All) Da aviso de todos los posibles errores de compilación
# -g       = (Debug) Guarda la información para debugear
CFLAGS=-Wunused -Wall -g


# Matemáticas (C Math library)
MTH=-lm

LIB=$(MTH)

# Directorios con elementos de uso común
COMMON=common

# Directorios que serán compilados a un programa
PROGRAMS=mst greedy

# Todos los directorios que contienen archivos de código
SRCDIR=$(COMMON) $(PROGRAMS)

# Todos los archivos .h de las carpetas comunes
DEPS := $(foreach i, $(COMMON), $(shell find $(SRC)/$(i) -name '*.h'))

# Todos los archivos .h
HDRFILES := $(shell find $(SRC) -name '*.h')

# Todos los archivos .c
SRCFILES := $(shell find $(SRC) -name '*.c')

# Archivos de objeto .o, un estado intermedio de compilación
OBJFILES := $(foreach i, $(SRCFILES), $(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(i)))

# Los directorios para los archivos de objeto .o
OBJDIR := $(patsubst $(SRC)/%, $(OBJ)/%, $(shell find $(SRC) -type d))


# Esta regla imprime que todo está listo
# Pero solo una vez que se hayan llamado las reglas $(OBJDIR) y $(PROGRAMS)
all: $(OBJDIR) $(PROGRAMS)
	@echo "done compiling"

# Esta regla elimina todo registro de compilación que se haya hecho
clean:
	@rm -fv $(PROGRAMS) && rm -rfv obj && echo "done cleaning"

# Esta regla crea los directorios donde se guardan los archivos de objeto .o
$(OBJDIR):
	@mkdir -p $@

# Esta regla mágica indica que las siguientes reglas necesitan dos pasadas
# Qué significa eso y por qué es importante no tiene importancia
.SECONDEXPANSION:

# Dependencias locales para un archivo .o
LOCAL_DEPS = $(filter $(patsubst $(OBJ)/%, $(SRC)/%, $(dir $(1)))%, $(HDRFILES))
# Flag de optimización para el código común
COMMON_OPT = $(if $(findstring $(word 2, $(subst /, ,$@)), $(COMMON)),$(BASE_OPT),$(OPT))

# Esta regla compila cada archivo de objeto .o
# Pero sólo si alguno de los siguientes fue modificado desde la última vez

obj/%.o: src/%.c $$(call LOCAL_DEPS,$$@) $(DEPS) Makefile
	@$(CC) $(CFLAGS) $(call COMMON_OPT) $< -c -o $@ $(LIB) && echo "compiled '$@'"

# Esta regla conecta y compila cada programa a partir de los .o
# Pero solo una vez que se haya llamado la regla anterior con lo siguiente
## todos los .o de la carpeta respectiva del programa
## todos los .o de los directorios comunes
$(PROGRAMS): $$(filter obj/$$@/% $(foreach i, $(COMMON), obj/$(i)/%), $(OBJFILES))
	@$(CC) $(CFLAGS) $(OPT) $^ -o $@ $(LIB) && echo "compiled '$@'"
