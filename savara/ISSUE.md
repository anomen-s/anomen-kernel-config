# 2025-03 - Nvidia issue
* downgrade nvidia
* try  nouveau drivers
* kernel option `nomodeset`
* Grub2 options, remove vga=somenumber and add xforcevesa or vga=normal
* GRUB_CMDLINE_LINUX_DEFAULT="vga=normal"
* reset terminal - `reset` of `stty sane`

