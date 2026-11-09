# PD2502 (vivo X300 / MT6993) — fox_16.0 TWRP 云编译

## 为什么用云编译
AOSP16 全树编译需要 ≥16 GB 内存 + ~250 GB 磁盘；本机 WSL 只有 7 GB 内存，
GitHub Actions 免费额度（ubuntu-22.04，4 核 / 16 GB / 90 GB 磁盘）刚好够。

## 使用步骤
1. 在 GitHub 新建一个空仓库（public），把本目录内容推上去：
   ```
   git init && git add . && git commit -m "PD2502 fox_16.0 device tree"
   git branch -M main
   git remote add origin https://github.com/<你的用户名>/<仓库名>.git
   git push -u origin main
   ```
2. 打开仓库 → Actions → “Build TWRP PD2502 (fox_16.0)” → Run workflow。
3. 约 2–4 小时后，在 Artifacts 下载 `PD2502-recovery`。
4. 刷入前必读下面的安全限制。

## 安全限制（血泪经验，务必遵守）
- **vendor_boot 的 vendor_ramdisk_size 不得超过 112,210,338**（原厂值）。
  超过会触发 LK 里 `mb_ramdisk.size` 的 `__assert_fail`，设备会卡第一屏后反复重启。
  构建产物请先自查：`python verify_vb.py <img>`（脚本见 lkwork 目录）。
- 刷写用 `fastboot flash vendor_boot_a`，保留原厂镜像做回滚：
  `fastboot flash vendor_boot_a vb_stock.img`（md5 `90FAD390239076F1A03834BB53D3CA37`）。
- `lk_b` 不要动；`lk_a` 当前是 fk10（伪回锁 + 免授权刷写），未动过。

## 已知需要在此设备树上继续补的东西
1. **内核模块**：把原厂 vendor_boot platform 分片 `lib/modules/` 里的
   `mediatek-drm.ko` / `panel_common.ko` / `vivo_display.ko` / `vivo_ts.ko` /
   `mtk_disp_notify.ko` / `vivo_bsp_engine.ko` / `leds-mtk*.ko` &
   `modules.load.recovery` 放进 `recovery/root/lib/modules/`。
2. **UDC**：本机真实 UDC 是 `16751000.usb0`（OF 默认写 `16701000.usb0`，会没有 adb）。
3. **触摸**：`vtsthp --thp 0` + `ro.vendor.vivo.product.model=PD2502`（已含脚本）。
4. **VINTF**：`vendor/etc/vintf/manifest/` 里必须声明 trustonic 的 keymint/gatekeeper，
   而不是小米的 mitee（否则 servicemanager 拒绝注册，报 UNKNOWN_ERROR）。
5. **TEE 注册表**：`/vendor/app/mcRegistry` + mcDriverDaemon 的 `-r` 列表（31 条 drbin）。

## 参考
- 设备树底座：`https://github.com/YorokobiMaster/OFRP_device_xiaomi_dash`（fox_16.0 / mt6991）
- TWRP A16 manifest：`https://github.com/TWRP-Test/platform_manifest_twrp_aosp`（分支 twrp-16.0）
