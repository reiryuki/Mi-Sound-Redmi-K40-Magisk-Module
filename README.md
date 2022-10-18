# Mi Sound Redmi K40 Magisk Module

## DISCLAIMER
- Dolby apps and blobs are owned by Dolby™.
- The MIT license specified here is for the Magisk Module, not for Dolby apps and blobs.
- MiSound app and blobs are owned by Xiaomi™.
- The MIT license specified here is for the Magisk Module, not for MiSound app and blobs.

## Descriptions
- Equalizer soundfx ported from Xiaomi Redmi K40 (alioth) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Global type soundfx
- Doesn't support ACDB module

## Sources
- https://dumps.tadiphone.dev/dumps/redmi/alioth qssi-user-12-SKQ1.211006.001-V13.0.3.0.SKHEUXM-release-keys
- MiSound.apk: apkmirror.com
- system_10: https://dumps.tadiphone.dev/dumps/xiaomi/ginkgo ginkgo-user-10-QKQ1.200114.002-V12.0.6.0.QCOEUXM-release-keys
- daxService.apk: https://dumps.tadiphone.dev/dumps/motorola/rhode user-12-S1SR32.38-124-3-a8403-release-keys
- libhwdap.so: Changed HEX fragment from da21499d2582294ffaae39537a04bcaa to 9108c3a04682ef4aadb8d53e26da0253
- libswdap.so: https://dumps.tadiphone.dev/dumps/motorola/rhode user-12-S1SR32.38-124-3-a8403-release-keys changed HEX fragment from da21499d2582294ffaae39537a04bcaa to a46db06a16c511466681452799218539

## Screenshots
- https://t.me/androidryukimods/488

## Requirements
- Architecture 64 bit Android 11 and up for the Dolby Atmos
- Miui ROM Android 8 and up for the MiSound EQ
- Magisk installed
- Miui Core Magisk Module v4.0 or above installed (except you are in Miui ROM)
- Recommended to use Magisk Delta for the systemless early init mount manifest.xml https://t.me/androidryukimodsdiscussions/100091

## WARNING!!!
- Possibility of bootloop or even softbrick or a service failure on Read-Only ROM if you don't use Magisk Delta.

## Installation Guide & Download Link
- Recommended to use Magisk Delta https://t.me/androidryukimodsdiscussions/100091
- Don't use ACDB Magisk Module!
- Remove any other Dolby module with different name (no need to remove if it's the same name)
- Reboot
- Install Miui Core Magisk Module v4.0 or above first: https://github.com/reiryuki/Miui-Core-Magisk-Module (except you are in Miui ROM)
- If your ROM has Dolby in-built, then you need to enable Dolby data clean-up for the first time (READ Optionals!)
- Install this module https://www.pling.com/p/1769560/ via Magisk Manager or Recovery
- Install AML Magisk Module https://zackptg5.com/android.php#aml only if using any other audio mod module
- Reboot

## Optionals & Troubleshootings
- https://t.me/androidryukimodsdiscussions/75400
- https://t.me/androidryukimodsdiscussions/60861
- https://t.me/androidryukimodsdiscussions/26764
- https://t.me/androidryukimodsdiscussions/29836

## Support & Bug Report
- https://t.me/androidryukimodsdiscussions/2618
- If you don't do above, issues will be closed immediately

## Tested on
- Android 12 AncientOS ROM
- Android 12.1 Nusantara ROM

## Known Issue
- misoundfx doesn't work except in Miui ROM
- Not all ROM is supported for the Mi Sound app

## Credits and contributors
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Thanks for Donations
- This Magisk Module is always will be free but you can however show us that you are care by making a donations:
- https://ko-fi.com/reiryuki
- https://www.paypal.me/reiryuki
- https://t.me/androidryukimodsdiscussions/2619


