# Copyright (C) 2015-2023 CE Programming
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

include $(CURDIR)/../common.mk

# TODO: atomic
BUILD_SRC := $(filter-out build/atomic.cpp.src,$(patsubst source/%,build/%.src,$(wildcard source/*.c source/*.cpp)))

EZCFLAGS := -S -ffreestanding -Wall -Wextra -Oz
EZCFLAGS += -D_EZ80 -isystem ../ce/include -isystem ../libc/include -mllvm -profile-guided-section-prefix=false
EZCFLAGS += -DEASTL_USER_CONFIG_HEADER="<__EASTL_user_config.h>"
EZCXXFLAGS := $(EZCFLAGS) -fno-exceptions -fno-rtti -fno-use-cxa-atexit
EZCXXFLAGS += -isystem include -isystem ../EABase/include/Common -isystem ../libcxx/include

CONFIG_H = include/__EASTL_user_config.h

WILDCARD_SRC = $(wildcard *.src) $(BUILD_SRC)
WILDCARD_EASTL_H := $(wildcard include/EASTL/*.h)
WILDCARD_EASTL_BONUS_H := $(wildcard include/EASTL/bonus/*.h)
WILDCARD_EASTL_INTERNAL_H := $(wildcard include/EASTL/internal/*.h)
# WILDCARD_EASTL_INTERNAL_ATOMIC_H := $(wildcard include/EASTL/internal/atomic/*.h)
WILDCARD_EABASE_H := $(wildcard ../EABase/include/Common/EABase/*.h)
WILDCARD_EABASE_CONFIG_H := $(wildcard ../EABase/include/Common/EABase/config/*.h)

all: $(BUILD_SRC)

build/%.c.src: source/%.c
	$(Q)$(call MKDIR,build)
	$(Q)$(EZCC) $(EZCFLAGS) $< -o $@

build/%.cpp.src: source/%.cpp
	$(Q)$(call MKDIR,build)
	$(Q)$(EZCC) $(EZCXXFLAGS) $< -o $@

clean:
	$(Q)$(call RMDIR,build)

install: all
	$(Q)$(call MKDIR,$(INSTALL_H))
	$(Q)$(call MKDIR,$(INSTALL_EABASE_H))
	$(Q)$(call MKDIR,$(INSTALL_EABASE_CONFIG_H))
	$(Q)$(call MKDIR,$(INSTALL_EASTL_H))
	$(Q)$(call MKDIR,$(INSTALL_EASTL_BONUS_H))
	$(Q)$(call MKDIR,$(INSTALL_EASTL_INTERNAL_H))
#	$(Q)$(call MKDIR,$(INSTALL_EASTL_INTERNAL_ATOMIC_H))
	$(Q)$(call MKDIR,$(INSTALL_EASTL))
	$(Q)$(call COPY,$(call NATIVEPATH,$(WILDCARD_SRC)),$(INSTALL_EASTL))
#	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(WILDCARD_EASTL_INTERNAL_ATOMIC_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_EASTL_INTERNAL_ATOMIC_H))
	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(WILDCARD_EASTL_INTERNAL_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_EASTL_INTERNAL_H))
	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(WILDCARD_EASTL_BONUS_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_EASTL_BONUS_H))
	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(WILDCARD_EASTL_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_EASTL_H))
	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(WILDCARD_EABASE_CONFIG_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_EABASE_CONFIG_H))
	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(WILDCARD_EABASE_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_EABASE_H))
	$(Q)$(call COPY,$(foreach file,$(call NATIVEPATH,$(CONFIG_H)),$(call QUOTE_ARG,$(file))),$(INSTALL_H))

.PHONY: all clean
