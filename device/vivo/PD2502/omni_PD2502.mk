$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_arm64.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/embedded.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/vivo/PD2502/device.mk)

PRODUCT_DEVICE := PD2502
PRODUCT_NAME := omni_PD2502
PRODUCT_BRAND := vivo
PRODUCT_MODEL := PD2502
PRODUCT_MANUFACTURER := vivo
