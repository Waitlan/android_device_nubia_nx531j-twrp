# Copyright (C) 2016 The CyanogenMod Project
#               2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a custom bootimage target file to be used on LineageOS
# Set these variables on your BoardConfig.mk
#
# DEVICE_BASE_BOOT_IMAGE := path/to/stuff/existingboot.img
# DEVICE_BASE_RECOVERY_IMAGE := path/to/stuff/existingrecovery.img
# BOARD_CUSTOM_BOOTIMG_MK := path/to/intel-boot-tools/boot.mk
#

LOCAL_PATH := $(call my-dir)


## Overload bootimg generation: Same as the original, using prebuilt kernel with BootSignature
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOT_SIGNER)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) --output $@
	$(BOOT_SIGNER) /boot $@ device/nubia/nx531j/bootsignature/verity.pk8 device/nubia/nx531j/bootsignature/verity.x509.pem $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

## Overload recoveryimg generation: Same as the original, using prebuilt kernel with BootSignature
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
		$(call build-recoveryimage-target, $@)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) --output $@
	$(BOOT_SIGNER) /recovery $@ device/nubia/nx531j/bootsignature/verity.pk8 device/nubia/nx531j/bootsignature/verity.x509.pem $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
