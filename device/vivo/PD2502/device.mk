LOCAL_PATH := device/vivo/PD2502

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/system/bin/vtsthp_start.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/vtsthp_start.sh

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware=mt6993 \
    ro.product.device=PD2502 \
    ro.vendor.vivo.product.model=PD2502
