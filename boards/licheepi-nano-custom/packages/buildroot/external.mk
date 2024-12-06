# include $(sort $(wildcard package/*/*.mk))
# include $(sort $(wildcard package/gcc-target/*.mk))
include $(sort $(wildcard ${BR2_EXTERNAL_LICHEEPI_NANO_CUSTOM_PATH}/package/gcc-target/*.mk))
