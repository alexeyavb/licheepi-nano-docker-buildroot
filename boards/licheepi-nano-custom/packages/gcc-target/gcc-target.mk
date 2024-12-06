################################################################################
#
# Common variables for the gcc-initial and gcc-final packages.
#
################################################################################

#
# Version, site and source
#
BR2_GCC_VERSION = "13.3.0"
GCC_VERSION = $(call qstrip,$(BR2_GCC_VERSION))
HOST_GCC_LICENSE = GPL-2.0, GPL-3.0, LGPL-2.1, LGPL-3.0
HOST_GCC_LICENSE_FILES = COPYING COPYING3 COPYING.LIB COPYING3.LIB

#
# make ext-toolchain symlinkls
#	ln -s /home/user/buildroot/2023.08.3/output/host/opt/ext-toolchain/bin/* /home/user/buildroot/2023.08.3/output/host/bin/

ifeq ($(BR2_GCC_VERSION_ARC),y)
GCC_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,gcc,$(GCC_VERSION))
GCC_SOURCE = gcc-$(GCC_VERSION).tar.gz
else
GCC_SITE = $(BR2_GNU_MIRROR:/=)/gcc/gcc-$(GCC_VERSION)
GCC_SOURCE = gcc-$(GCC_VERSION).tar.xz
endif

HOST_GCC_LICENSE = GPL-2.0, GPL-3.0, LGPL-2.1, LGPL-3.0
HOST_GCC_LICENSE_FILES = COPYING COPYING3 COPYING.LIB COPYING3.LIB

HOST_GCC_COMMON_CONF_ENV = \
        MAKEINFO=missing

HOST_GCC_COMMON_MAKE_OPTS = \
        gcc_cv_libc_provides_ssp=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)
#
# Xtensa special hook
#
define HOST_GCC_XTENSA_OVERLAY_EXTRACT
        $(call arch-xtensa-overlay-extract,$(@D),gcc)
endef

#
# Apply patches
#

# gcc is a special package, not named gcc, but gcc-initial and
# gcc-final, but patches are nonetheless stored in package/gcc in the
# tree, and potentially in BR2_GLOBAL_PATCH_DIR directories as well.
define HOST_GCC_APPLY_PATCHES
        for patchdir in \
            package/gcc-target/$(GCC_VERSION) \
            $(addsuffix /gcc/$(GCC_VERSION),$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
            $(addsuffix /gcc,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) ; do \
                if test -d $${patchdir}; then \
                        $(APPLY_PATCHES) $(@D) $${patchdir} \*.patch || exit 1; \
                fi; \
        done
endef

HOST_GCC_EXCLUDES = \
        libjava/* libgo/*

#
# Create 'build' directory and configure symlink
#

define HOST_GCC_CONFIGURE_SYMLINK
	/home/user/buildroot/2023.08.3/output/host/opt/ext-toolchain/relocate-sdk.sh
        ln -sf /home/user/buildroot/2023.08.3/output/host/opt/ext-toolchain/bin/* /home/user/buildroot/2023.08.3/output/host/bin/
        mkdir -p $(@D)/build
        ln -sf ../configure $(@D)/build/configure
        ln -sf /home/user/buildroot/2023.08.3/output/host/opt/ext-toolchain/bin/* /home/user/buildroot/2023.08.3/output/host/bin/
endef

################################################################################
#
# gcc-target
#
################################################################################

GCC_TARGET_VERSION = $(GCC_VERSION)
GCC_TARGET_SITE = $(GCC_SITE)
GCC_TARGET_SOURCE = $(GCC_SOURCE)

# Use the same archive as gcc-initial and gcc-final
GCC_TARGET_DL_SUBDIR = gcc

GCC_TARGET_DEPENDENCIES = gmp mpfr mpc

# First, we use HOST_GCC_COMMON_MAKE_OPTS to get a lot of correct flags (such as
# the arch, abi, float support, etc.) which are based on the config used to
# build the internal toolchain
GCC_TARGET_CONF_OPTS = $(HOST_GCC_COMMON_CONF_OPTS)
# Then, we modify incorrect flags from HOST_GCC_COMMON_CONF_OPTS
GCC_TARGET_CONF_OPTS += \
	--with-sysroot=/ \
	--with-build-sysroot=$(STAGING_DIR) \
	--disable-__cxa_atexit \
	--with-gmp=$(STAGING_DIR) \
	--with-mpc=$(STAGING_DIR) \
	--with-mpfr=$(STAGING_DIR)
# Then, we force certain flags that may appear in HOST_GCC_COMMON_CONF_OPTS
GCC_TARGET_CONF_OPTS += \
	--disable-libquadmath \
	--disable-libsanitizer \
	--disable-plugin \
	--disable-lto
# Finally, we add some of our own flags
GCC_TARGET_CONF_OPTS += \
	--enable-languages=c \
	--disable-boostrap \
	--disable-libgomp \
	--disable-nls \
	--disable-libmpx \
	--disable-gcov \
	$(EXTRA_TARGET_GCC_CONFIG_OPTIONS)

GCC_TARGET_CONF_ENV = $(HOST_GCC_COMMON_CONF_ENV)

GCC_TARGET_MAKE_OPTS += $(HOST_GCC_COMMON_MAKE_OPTS)

# Install standard C headers (from glibc)
define GCC_TARGET_INSTALL_HEADERS
	cp -r $(STAGING_DIR)/usr/include $(TARGET_DIR)/usr
endef
GCC_TARGET_POST_INSTALL_TARGET_HOOKS += GCC_TARGET_INSTALL_HEADERS

GCC_TARGET_GLIBC_LIBS = \
	libBrokenLocale.so libanl.so libbfd.so libc.so libcrypt.so libdl.so \
	libm.so libnss_compat.so libnss_db.so libnss_files.so libnss_hesiod.so \
	libpthread.so libresolv.so librt.so libthread_db.so libutil.so

# Install standard C libraries (from glibc)
define GCC_TARGET_INSTALL_LIBS
	for libpattern in $(GCC_TARGET_GLIBC_LIBS); do \
		$(call copy_toolchain_lib_root,$$libpattern) ; \
	done
	cp -dpf $(STAGING_DIR)/usr/lib/*crt*.o $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/usr/lib/*_nonshared.a $(TARGET_DIR)/usr/lib/
endef
GCC_TARGET_POST_INSTALL_TARGET_HOOKS += GCC_TARGET_INSTALL_LIBS

# Remove unnecessary files (extra links to gcc binaries, and libgcc which is
# already in `/lib`)
define GCC_TARGET_RM_FILES
	rm -f $(TARGET_DIR)/usr/bin/$(ARCH)-buildroot-linux-gnu-gcc*
	rm -f $(TARGET_DIR)/usr/lib/libgcc_s*.so*
	rm -f $(TARGET_DIR)/usr/$(ARCH)-buildroot-linux-gnu/lib/ldscripts/elf32*
	rm -f $(TARGET_DIR)/usr/$(ARCH)-buildroot-linux-gnu/lib/ldscripts/elf64b*
endef
GCC_TARGET_POST_INSTALL_TARGET_HOOKS += GCC_TARGET_RM_FILES

$(eval $(autotools-package))
