# -------------------------------------------------------
#
# File: Makefile
#
# Copyright (c) 2025 KingSolomon1954
#
# SPDX-License-Identifier: MIT
#
# -------------------------------------------------------
#
# Start Section
# bash-bootstrap
# End Section
#
# -------------------------------------------------------

TOP     := .
D_SRC   := $(TOP)/src
D_DOCS  := $(TOP)/docs
D_TOOLS := $(TOP)/tools
D_TEST  := $(TOP)/test
D_ETC   := $(TOP)/etc
D_BLD   := $(TOP)/_build
D_MAK   := $(D_TOOLS)/submakes
D_SCP   := $(D_TOOLS)/scripts

all: all-relay

# include $(D_TEST)/unit-test.mak
# include $(D_DOCS)/docs.mak
# include $(D_MAK)/version-vars.mak
# include $(D_MAK)/bash-static-analysis.mak
# include $(D_MAK)/release-tarball.mak
# include $(D_MAK)/help.mak

all-relay:
	@echo "Not yet implemented"

clean:
	rm -rf $(D_BLD)

.PHONY: all all-relay clean

# ------------ Help Section ------------

HELP_TXT += "\n\
all,   Build the repo\n\
clean, Deletes $(BLD)\n\
"
