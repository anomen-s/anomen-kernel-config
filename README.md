# Repo
My personal repo for keeping kernel configuration, various scripts, tools, and general configuration files.

Not much interesting stuff here. Except maybe protect.sh script and pre-commit hook, which checks if there is no plaintext file to be commited
(i.e. no file1 and file1.gpg in the commit).

---
 ./protect.sh			enter password, which will be stored in ~/.config/github-private-passphrase
 ./protect.sh enc		encrypt files for which exists *.gpg file
 ./protect.sh dec		decrypt *.gpg files
---
