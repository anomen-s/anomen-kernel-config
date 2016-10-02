#!/bin/sh

echo Update start
date
# PULL
for A in $HOME/oss
do 
  if [ -d "${HOME}/oss/${A}.git" ]
  then
    echo "### REPO: $A"
    cd $HOME/oss/$A
    git pull
    git gc
  fi
done

for A in aswiki oe/povidky Documents
do
  echo "### REPO: $A"
  cd $HOME/$A
  git pull
  git push
  git gc
done


# GC
for A in $HOME/repos/*.git
do 
  echo "### REPO: $A"
  cd $A
  git gc
done


#echo "### REPO: /usr/src/rpi-linux.git"
#cd /usr/src/rpi-linux.git
#git pull

#for A in aswiki
#do
#  echo "### REPO: $A"
#  cd $HOME/$A
#  svn up
#done


#M="auto commit on `date '+%Y-%m-%d %H:%M'`"

# PUSH
#for A in grimrock
#do 
#  echo "### REPO: $A"
#  cd $HOME/$A
#  git add *
#  git commit -m "$M"
#  git push
#done
