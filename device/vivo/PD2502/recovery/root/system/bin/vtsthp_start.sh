#!/system/bin/sh
# PD2502 触摸守护：必须使用真 vendor 的 vtsthp + 正确机型名
mount -t erofs -o ro /dev/block/by-name/vendor /vendor 2>/dev/null
M=$(sed -n 's/^ro.vendor.vivo.product.model=//p' /vendor/build.prop 2>/dev/null | head -1)
[ -z "$M" ] && M=PD2502
setprop ro.vendor.vivo.product.model "$M"
mkdir -p /mnt/vendor/persist/touchscreen
chmod 0664 /dev/thp-dev 2>/dev/null
echo 0 > /dev/thp-dev 2>/dev/null
setenforce 0 2>/dev/null
while true; do
  if [ -z "$(pidof vtsthp)" ]; then
    LD_LIBRARY_PATH=/vendor/lib64:/system/lib64 setsid /vendor/bin/vtsthp --thp 0 >/dev/null 2>&1 &
  fi
  sleep 5
done
