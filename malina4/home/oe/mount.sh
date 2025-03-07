#!/bin/sh -x

sudo cryptsetup luksOpen /dev/disk/by-uuid/535cacad-3db9-4662-9529-5b4785e196ef oe || exit 4

sudo mount /dev/mapper/oe $HOME/oe/local || exit 5

