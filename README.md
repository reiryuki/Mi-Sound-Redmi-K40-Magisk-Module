# Mi Sound and Dolby Atmos Redmi K40 Magisk Module

## DISCLAIMER
- Dolby apps and blobs are owned by Dolby™.
- The MIT license specified here is for the Magisk Module only, not for Dolby apps and blobs.
- MiSound app and blobs are owned by Xiaomi™.
- The MIT license specified here is for the Magisk Module only, not for MiSound app and blobs.

## Descriptions
- Equalizers soundfx ported from Xiaomi Redmi K40 (alioth) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Global type soundfx
- Mi Sound, Dolby Atmos, & Bluetooth microphone enhancer
- Dolby Atmos changes/spoofs ro.product.brand to Redmi, ro.product.device to alioth, & ro.product.manufacturer to Xiaomi which may break some system apps and features functionality
- Dolby Atmos conflicted with vendor.dolby_v3_6.hardware.dms360@2.0-service & vendor.dolby.hardware.dms@1.0-service

## Sources
- https://dumps.tadiphone.dev/dumps/redmi/alioth qssi-user-12-SKQ1.211006.001-V13.0.3.0.SKHEUXM-release-keys
- MiSound.apk: https://apkmirror.com com.miui.misound by Xiaomi Inc.
- system_10: https://dumps.tadiphone.dev/dumps/xiaomi/ginkgo ginkgo-user-10-QKQ1.200114.002-V12.0.6.0.QCOEUXM-release-keys
- daxService.apk: https://dumps.tadiphone.dev/dumps/motorola/rhode user-12-S1SR32.38-124-3-a8403-release-keys

## Screenshots
- https://t.me/androidryukimods/488

## Requirements
- Magisk or KernelSU installed (Recommended to use Magisk Delta/Kitsune Mask for systemless early init mount manifest.xml if your ROM is Read-Only https://t.me/androidryukimodsdiscussions/100091)
- Miui Core Magisk Module installed in non-Miui ROM
- Mi Sound EQ
  - Miui ROM (In non-Miui ROM, the UI still showing even it doesn't work)
  - Android 8 and up
  - Android 10 and bellow requires 32 bit architecture or 64 bit architecture with 32 bit library support, otherwise not
- Dolby Atmos EQ
  - 64 bit architecture
  - Android 11 and up

## WARNING!!!
- Possibility of bootloop or even softbrick or a service failure on Read-Only ROM if you don't use Magisk Delta/Kitsune Mask.

## Installation Guide & Download Link
- Recommended to use Magisk Delta/Kitsune Mask https://t.me/androidryukimodsdiscussions/100091
- Don't use ACDB Magisk Module!
- Remove any other else Dolby Magisk module with different name (no need to remove if it's the same name)
- Reboot
- Install Miui Core Magisk Module first if you are in non-Miui ROM: https://github.com/reiryuki/Miui-Core-Magisk-Module
- If you have Dolby in-built in your ROM, then you need to activate data.cleanup=1 at the first time install (READ Optionals bellow!)
- Install this module https://www.pling.com/p/1769560/ via Magisk app or KernelSU app or Recovery if Magisk installed
- Install AML Magisk Module https://t.me/androidryukimodsdiscussions/29836 only if using any other audio mod module
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package-dolby.txt (and your home launcher app also) (enable show system apps) and reboot after
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot after

## Optionals & Troubleshootings
- https://t.me/androidryukimodsdiscussions/75400
- Global: https://t.me/androidryukimodsdiscussions/60861
- Global: https://t.me/androidryukimodsdiscussions/29836
- Stream: https://t.me/androidryukimodsdiscussions/26764

## Support & Bug Report
- https://t.me/androidryukimodsdiscussions/2618
- If you don't do above, issues will be closed immediately

## Tested on
- Android 12 AncientOS ROM
- Android 12.1 Nusantara ROM
- Android 13 AOSP ROM & CrDroid ROM

## Credits and contributors
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Thanks for Donations
This Magisk Module is always will be free but you can however show us that you are care by making a donations:
- https://ko-fi.com/reiryuki
- https://www.paypal.me/reiryuki
- https://t.me/androidryukimodsdiscussions/2619


