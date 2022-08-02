#!/bin/sh

for A in `ls  | grep  '^[0-9]'`
do
 F=0
 ls $A/*.mp4 2>/dev/null && F=1
 ls $A/*.mkv 2>/dev/null && F=1
 echo "A:$A F:$F"
 if [ "$F" = "1" ]
 then
   echo "$A"
   mv $A/*.mp4 . 2> /dev/null
   mv $A/*.mkv . 2> /dev/null
   rm -vf $A/*.txt $A/*.log
   rmdir -v "$A"
 fi

done



#find . -mindepth 1 -type f -size +1k -name '*.mkv' -o -name '*.mp4' |  grep -E '^./[0-9]'

