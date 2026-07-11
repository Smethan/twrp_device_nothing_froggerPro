# ------------------
# TWRP Configuration
# ------------------

# Display
TARGET_SCREEN_DENSITY := 440
TARGET_SCREEN_HEIGHT := 2800
TARGET_SCREEN_WIDTH := 1260

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_SCREEN_BLANK_ON_BOOT := true
TW_NO_INPUT_DEVICES := false
TW_INPUT_BLACKLIST := "null"
TW_DEFAULT_LANGUAGE     := en
TW_USE_TOOLBOX          := true
TW_INCLUDE_NTFS_3G      := true
TW_INCLUDE_FUSE_EXFAT   := true
TW_INCLUDE_FUSE_NTFS    := true
TW_INCLUDE_REPACKTOOLS  := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_RESETPROP    := true
TW_EXTRA_LANGUAGES      := true
TW_EXCLUDE_APEX         := true
TW_INCLUDE_FASTBOOTD    := true

TW_LOAD_VENDOR_MODULES := "haptic.ko hapticdrv.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# Haptics: intentionally disabled in recovery. With the AIDL haptics path enabled, every touch
# calls AServiceManager_getService() for the vibrator HAL on the GUI thread; that HAL never runs
# in recovery, so the call blocks ~5s (retrying) before returning NULL -> severe input lag /
# frozen redraw. Disabling this makes vibrate() take the non-blocking sysfs fallback (no-op here).
# Working haptics isn't feasible in recovery anyway: the real LRA (AAC rt6010) needs its HAL to
# load waveform RAM + calibrate f0, and that HAL can't even link (needs libpalclient.so / audio PAL).
#TW_SUPPORT_INPUT_AIDL_HAPTICS := true
#TW_SUPPORT_INPUT_AIDL_HAPTICS_FQNAME := "IVibrator/default"
#TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true

# Screen
TW_MAX_BRIGHTNESS := 5000
TW_CUSTOM_CLOCK_POS := "590"
TW_FRAMERATE := 144

# CPU Temperature & Battery
TW_CUSTOM_CPU_TEMP_PATH := /sys/class/thermal/thermal_zone10/temp
TW_CUSTOM_BATTERY_PATH := "/sys/class/power_supply/battery"
HEALTHD_USE_BATTERY_INFO := true

# USB
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true

# Little hack (some reason libhardware.so isn't ending up compiled)
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hidl.allocator@1.0 \
    android.hidl.memory@1.0 \
    android.hidl.memory.token@1.0 \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service\
    libdmabufheap \
    libhidlmemory \
    libhardware \
    libion \
    libnetutils \
    vendor.display.config@1.0 \
    vendor.display.config@2.0 \
    android.hardware.vibrator-service.nothing\
    libdebuggerd_client \
    android.hardware.common-V2-ndk

TW_OVERRIDE_SYSTEM_PROPS := \
    "ro.build.product;ro.build.fingerprint=ro.vendor.build.fingerprint;ro.build.version.incremental"
TW_OVERRIDE_PROPS_ADDITIONAL_PARTITIONS := vendor
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.allocator@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.memory@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.memory.token@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdmabufheap.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libhidlmemory.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libnetutils.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdebuggerd_client.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libxml2.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.common-V2-ndk.so

# libxml2.so is needed by libdrmfs.so (qseecomd's dep chain); RECOVERY_LIBRARY_SOURCE_FILES
# is the mechanism that pulls a built AOSP lib into the recovery ramdisk in this tree --
# plain PRODUCT_PACKAGES inclusion does not (see Part J notes).
#
# android.hardware.common-V2-ndk.so is needed by the restored real vendor.qti.hardware.
# display.config-V7-ndk.so (libops.so's dep chain, see Part L/M/N) -- built from our own
# A14 source (hardware/interfaces/common/aidl, version 2 is present in aidl_api/) rather
# than copied from the A16 dump, to avoid introducing another cross-version prebuilt.

# Include EDL mode
TW_HAS_EDL_MODE := true

# Encryption
TW_KEYMASTER_VERSION := 4.1 # Force Keymaster version -- matches upstream's downgrade to keymint-V1/gatekeeper@1.0
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
#TW_INCLUDE_OMAPI := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace
