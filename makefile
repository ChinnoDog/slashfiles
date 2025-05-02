# Do not modify this file. Add makefiles to `makefile.d`.

MAKEFILES := $(shell find ./makefile.d -type f -name "*.mk" | sort)
include $(MAKEFILES)
