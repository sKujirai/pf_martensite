# Makefile

## TARGET
CPP_MAIN = pf_martensite.cpp
TARGET_DBG = pf_martensite_dev
TARGET_PROD = pf_martensite_prod

## C++ compiler
CXX := g++

## Compiler option
CPPFLAGS =
LDFLAGS =  -L/opt/VtkMesh/VtkMesh/
LIBS = -lm -pthread -lstdc++fs -lmeshvtkw
DBG_LEVEL := 1

## Header files
INCLUDE = -I/usr/local/include -I./ -I/opt/VtkMesh/

## C++ source files
EXCLUDE := .git% cmake% build% $(CPP_MAIN)
CPPS = $(shell find * -name *.cpp)
SRCS = $(filter-out $(EXCLUDE), $(CPPS))
DIRS = $(dir $(SRCS))

## User defined macro
USR_MACRO :=
USR_MACRO_R :=
OPT_MCR = $(addprefix -D, $(USR_MACRO))
OPT_MCR_R = $(addprefix -D, $(USR_MACRO_R))

#*** Parallelization
PARA_BACKEND := OMP
CPP_PARA =
ifeq ($(PARA_BACKEND),OMP)
	LIBS += -lgomp
	CPP_PARA += -fopenmp
endif

### Debug
#### Compiler option
CPPFLAGS_DBG =
ifeq ($(DBG_LEVEL),2)
	CPPFLAGS_DBG += $(CPPFLAGS) -O0 -MMD -MP -g -std=c++17 -Wall -Wextra $(OPT_MCR) $(MKL_MCR) $(CPP_PARA)
else ifeq ($(DBG_LEVEL),3)
	CPPFLAGS_DBG += $(CPPFLAGS) -O2 -MMD -MP -g -std=c++17 -Wall -Wextra $(OPT_MCR) $(MKL_MCR) $(CPP_PARA)
else
	CPPFLAGS_DBG += $(CPPFLAGS) -O0 -MMD -MP -g -std=c++17 -Wall -Wextra $(OPT_MCR) $(MKL_MCR)
endif
#### Set directories
OBJ_DIR_DBG := ./build_debug
SUB_DIR_DBG = $(addprefix $(OBJ_DIR_DBG)/, $(DIRS))
OBJS_DBG = $(addprefix $(OBJ_DIR_DBG)/, $(patsubst %.cpp, %.o, $(SRCS)))
DEPENDS_DBG = $(OBJS_DBG:.o=.d)
#### Rule
$(OBJ_DIR_DBG)/%.o: %.cpp
	@[ -d  $(OBJ_DIR_DBG)   ] || mkdir -p $(OBJ_DIR_DBG)
	@[ -d "$(SUB_DIR_DBG)" ] || mkdir -p $(SUB_DIR_DBG)
	$(CXX) $(CPPFLAGS_DBG) $(INCLUDE) -o $@ -c $<

### Release
#### Compiler option
CPPFLAGS_REL := $(CPPFLAGS) -O3 -march=native -MMD -MP -DNDEBUG -std=c++17 $(OPT_MCR_R) $(MKL_MCR) $(CPP_PARA)
#### Set directories
OBJ_DIR_REL := ./build_release
SUB_DIR_REL = $(addprefix $(OBJ_DIR_REL)/, $(DIRS))
OBJS_REL = $(addprefix $(OBJ_DIR_REL)/, $(patsubst %.cpp, %.o, $(SRCS)))
DEPENDS_REL = $(OBJS_REL:.o=.d)
#### Rule
$(OBJ_DIR_REL)/%.o: %.cpp
	@[ -d  $(OBJ_DIR_REL)   ] || mkdir -p $(OBJ_DIR_REL)
	@[ -d "$(SUB_DIR_REL)" ] || mkdir -p $(SUB_DIR_REL)
	$(CXX) $(CPPFLAGS_REL) $(INCLUDE) -o $@ -c $<

## Make rule
all: debug release

debug: $(OBJS_DBG) $(CPP_MAIN)
	$(CXX) $(CPP_MAIN) $(OBJS_DBG) $(CPPFLAGS) $(INCLUDE) -o $(TARGET_DBG) $(LDFLAGS) $(LIBS)

release: $(OBJS_REL) $(CPP_MAIN)
	$(CXX) $(CPP_MAIN) $(OBJS_DBG) $(CPPFLAGS) $(INCLUDE) -o $(TARGET_PROD) $(LDFLAGS) $(LIBS)

.PHONY: clean

cleanall:
	rm -rf $(OBJ_DIR_DBG) $(OBJ_DIR_REL) *.d *~ */*~ *.stackdump *.o */#*# $(TARGET_DBG) $(TARGET_PROD)

clean:
	rm -rf $(OBJ_DIR_DBG) $(OBJ_DIR_REL) *.d

-include $(DEPENDS_DBG) $(DEPENDS_REL)
