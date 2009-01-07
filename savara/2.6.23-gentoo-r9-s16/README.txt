2.6.22-gentoo-r9-s11
====================
- added samba, cifs
- most reliable so far

2.6.23-gentoo-r3-s12
====================
- removed USB UHCI
-forcedeth as module

2.6.23-gentoo-r3-s13
====================
- added CONFIG_SENSORS_ADM1021 (detected by sensors-detect, with low certanity)
- vmnet crashes but works

2.6.23-gentoo-r6-s14
====================
- removed git LOCALVERSION_AUTO
- added CONFIG_BLK_DEV_NBD for mounting VMWare

2.6.23-gentoo-r6-s15
====================
- added PPP
- returned UHCI - causes failed asserts in vmware ?
- forcedeth in kernel

2.6.23-gentoo-r9-s16
====================
- kernel debug
+ printf timestamps
- cpufreq powersave governor
- crypto HW
+ cifs stats

