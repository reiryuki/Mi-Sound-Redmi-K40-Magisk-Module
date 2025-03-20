# Mi Sound and Dolby Atmos Redmi K40 Magisk Module

## DISCLAIMER
- Dolby apps and blobs are owned by Dolby™.
- The MIT license specified here is for the Magisk Module only, not for Dolby apps and blobs.
- MiSound app and blobs are owned by Xiaomi™.
- The MIT license specified here is for the Magisk Module only, not for MiSound app and blobs.

## Descriptions
- Equalizers sound effect ported from Xiaomi Redmi K40 (alioth) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Global type sound effect
- Mi Sound, Dolby Atmos, & Bluetooth microphone enhancer
- Dolby Atmos changes/spoofs ro.product.brand to Redmi, ro.product.device to alioth, & ro.product.manufacturer to Xiaomi which may break some system apps and features functionality
- Dolby Atmos conflicted with `vendor.dolby_v3_6.hardware.dms360@2.0-service`, `vendor.dolby_sp.hardware.dmssp@2.0-service`, & `vendor.dolby.hardware.dms@1.0-service`

## Sources
- https://dumps.tadiphone.dev/dumps/redmi/alioth qssi-user-12-SKQ1.211006.001-V13.0.3.0.SKHEUXM-release-keys
- libsqlite.so: https://dumps.tadiphone.dev/dumps/zte/p855a01 msmnile-user-11-RKQ1.201221.002-20211215.223102-release-keys
- MiSound.apk: https://apkmirror.com com.miui.misound by Xiaomi Inc.
- daxService.apk: https://dumps.tadiphone.dev/dumps/motorola/rhode user-12-S1SR32.38-124-3-a8403-release-keys
- libhidlbase.so: CrDroid ROM Android 13
- android.hardware.audio.effect@*-impl.so: https://dumps.tadiphone.dev/dumps/oneplus/op594dl1 qssi-user-14-UKQ1.230924.001-1701915639192-release-keys--US
- libmagiskpolicy.so: Kitsune Mask R6687BB53

## Screenshots
- https://t.me/androidryukimods/488

## Requirements
- Magisk or KernelSU installed (Recommended to use Magisk Delta/Kitsune Mask for systemless early init mount manifest.xml if your ROM is Read-Only https://t.me/ryukinotes/49)
- Miui Core Magisk Module installed in non-Miui ROM
- Mi Sound EQ
  - Miui ROM (In non-Miui ROM, the UI still showing even it doesn't work)
  - Android 8 (SDK 26) and up
  - Earphone/headphone connected
- Dolby Atmos EQ
  - arm64-v8a architecture
  - Android 11 (SDK 30) and up

## WARNING!!!
- Possibility of bootloop or even softbrick or a service failure on Read-Only ROM if you don't use Magisk Delta/Kitsune Mask.

## Installation Guide & Download Link
- Recommended to use Magisk Delta/Kitsune Mask https://t.me/ryukinotes/49
- Remove any other else Dolby MAGISK MODULE with different name (no need to remove if it's the same name)
- Reboot
- Install Miui Core Magisk Module first if you are in non-Miui ROM: https://github.com/reiryuki/Miui-Core-Magisk-Module
- If you have Dolby in-built in your ROM, then you need to activate data.cleanup=1 at the first time install (READ Optionals bellow!)
- Install this module https://www.pling.com/p/1769560/ via Magisk app or KernelSU app or Recovery if Magisk installed
- Install AML Magisk Module https://t.me/ryukinotes/34 only if using any other else audio mod module
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package-dolby.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards
- If you have sensors issue (fingerprint, proximity, gyroscope, etc), then READ Optionals bellow!

## Optionals
- https://t.me/ryukinotes/79
- Global: https://t.me/ryukinotes/35
- Stream: https://t.me/ryukinotes/52

##Troubleshootings
- https://t.me/ryukinotes/79
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- @HuskyDG
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- @HELLBOY017
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
- https://t.me/ryukinotes/25


