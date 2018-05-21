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
 echo Decrypting
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
      gpg --quiet --batch --passphrase-file "$PW_FILE" --armor --output "$FT" --decrypt "$F" || echo Canot decrypt "$F". Deleting.
      if cmp --quiet "$FP" "$FT"
      then
        echo File not changed, deleting: "$FP"
        rm --force "$FT" > /dev/null
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
  FT="${FO}-${RANDOM}"
  gpg --quiet --batch --passphrase-file "$PW_FILE" --armor --output "$FT" --decrypt "$F" || exit 5
  if [ ! -e "$FO" ]
  then
    echo Decrypt file: "$F"
    mv "$FT" "$FO"
  elif cmp --quiet "$FT" "$FO"
  then
    echo File not changed: "$FO"
  else
    echo Not overwriting changed file: "$FO"
  fi
  rm --force "$FT" > /dev/null
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
    echo "Usage: "
    echo "	$0 encrypt	find all encrypted files (*.gpg) for which exists plaintext file and replace them with encrypted plaintexts "
    echo "	$0 decrypt	decrypt all encrypted files (*.gpg)"
    exit 1
esac

