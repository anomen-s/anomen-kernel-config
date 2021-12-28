#/bin/sh

exit

dd if=/dev/urandom of=$HOME/.local/secure.luks bs=1M count=10240

cryptsetup --cipher aes-xts-plain -s 512 --verbose --verify-passphrase luksFormat $HOME/.local/secure.luks

sudo mkfs.ext3 -L SECURE_DATA -m 1 -N 100000 -v  /dev/mapper/secure
