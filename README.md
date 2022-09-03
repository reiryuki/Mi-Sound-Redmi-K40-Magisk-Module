# Mi Sound Redmi M2012K11AC Magisk Module

## DISCLAIMER
- Dolby apps and blobs are owned by Dolby™.
- The MIT license specified here is for the Magisk Module, not for Dolby apps and blobs.

## Descriptions
- Dolby Atmos soundfx equalizer with MiSound app ported from Xiaomi Redmi M2012K11AC (alioth) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Global type soundfx
- Nokia OZO Audio Capture, improves audio quality on video/audio recordings
- Doesn't support ACDB module

## Sources
- https://dumps.tadiphone.dev/dumps/redmi/alioth qssi-user-12-SKQ1.211006.001-V13.0.3.0.SKHEUXM-release-keys
- vendor.dolby.hardware.dms@2.0-impl.so: https://dumps.tadiphone.dev/dumps/redmi/alioth qssi-user-11-RKQ1.200826.002-V12.5.7.0.RKHINXM-release-keys
- MiSound.apk: apkmirror.com
- system_10: https://dumps.tadiphone.dev/dumps/xiaomi/ginkgo ginkgo-user-10-QKQ1.200114.002-V12.0.6.0.QCOEUXM-release-keys
- daxService.apk: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible qssi-user-11-RP1A.201005.001-2103312144-release-keys
- libswdap.so: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible qssi-user-11-RP1A.201005.001-2103312144-release-keys
- libhwdap.so: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible qssi-user-11-RP1A.201005.001-2103312144-release-keys
- libdapparamstorage.so: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible qssi-user-11-RP1A.201005.001-2103312144-release-keys
- libdlbdsservice.so: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible qssi-user-11-RP1A.201005.001-2103312144-release-keys
- dax-default.xml: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible qssi-user-11-RP1A.201005.001-2103312144-release-keys
- system_dolby_10: https://dumps.tadiphone.dev/dumps/oneplus/oneplus8visible OnePlus8Visible-user-10-QKQ1.191222.002-2007221621-release-keys
- libswvqe.so: LENOVO TB-J606F

## Screenshots
- https://t.me/androidryukimods/488

## Requirements
- Android 8 and up + Miui ROM for the MiSound EQ
- Android 9 and up for the Dolby Atmos
- Architecture 64 bit for the Dolby Atmos
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

## Bugs
- misoundfx doesn't work except in Miui ROM
- Dolby from Miui is unsupported for any other devices or it just a placebo effect because they doesn't have any dolby service nor the other matched one for processing the dap effects, so the dap here is taken from OnePlus. That's why voice preset doesn't work.
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


