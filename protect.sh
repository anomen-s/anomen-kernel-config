#!/bin/sh

EXEC="$0"
PW_FILE="$HOME/.config/github-private-passphrase"

getpw() {
    echo No password defined. "Enter: "
    read PW
    echo "Writing $PW_FILE..."
    echo "$PW" > $PW_FILE
    echo "" >> $PW_FILE
    echo "This is password for sensitive files in repository https://github.com/anomen-s/anomen-kernel-config.git" >> $PW_FILE
    PW=x
}

if [ ! -f $PW_FILE ]
then
  getpw
fi

decrypt() {
 echo Decryting
 find . -type f -name '*.gpg' -exec "$EXEC" filedec '{}' ';'
}

encrypt() {
 echo Encrypting.
 find . -type f -name '*.gpg' -exec "$EXEC" fileenc '{}' ';'
}

fileenc() {
  F="$1"
  FP="${F%.gpg}"
  if [ -f "$FP" -a -f "$F" ]
  then
      # check if plaintext file was changed
      FT="${FP}-${RANDOM}"
      gpg --quiet --batch --passphrase-file "$PW_FILE" --armor --output "$FT" --decrypt "$F" || exit 6
      if cmp --quiet "$FP" "$FT"
      then
        echo File not changed, deleting: "$FP"
        rm --force "$FT"
        rm --force "$FP"
        exit 0
      else
        rm "$FT"
      fi
  fi

  # if there is plaintext file, encrypt it
  if [ -f "$FP" ]
  then
   echo Encrypt and delete file: "$FP"
   rm  --force "$F"
   gpg --quiet --batch --passphrase-file "$PW_FILE" --armor --emit-version --emit-version --symmetric --cipher-algo AES256 --output "$F" "$FP" || exit 4
   rm --verbose --force "$FP"
  else
   echo File already encrypted: "$FP"
  fi
}

filedec() {
  F="$1"
  FO="${F%.gpg}"
  echo Decrypt file: "$F"
  rm --verbose --force "$FO"
  gpg --quiet --batch --passphrase-file "$PW_FILE" --armor --output "$FO" --decrypt "$F" || exit 5
}

case "$1" in
 decrypt|dec)
    decrypt
 ;;
 encrypt|enc)
    encrypt
 ;;
 fileenc)
    fileenc "$2"
 ;;
 filedec)
    filedec "$2"
 ;;
 *)
    echo Invalid command
    exit 1
esac

