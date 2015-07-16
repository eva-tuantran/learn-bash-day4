#!/bin/bash
START=$(date +%s)

echo "========== Process get file path =========="
END=5
FPATH="download/"

if [ ! -f $FPATH"logs.log" ]; then
	echo "" > $FPATH"logs.log"
fi

for((i=1; i<=END;i++))
do
	if [ ! -f $FPATH"result"$i".log.gz" ]; then
		curl "http://192.168.33.99/result.day0$i.log.gz" > $FPATH"result$i.log.gz"
    	zcat $FPATH"result"$i".log.gz" >> $FPATH"logs.log"
	fi
done

echo "========== Number of unique user in total =========="
COUNT=$(wc -l $FPATH"logs.log")

#
# Number unique user id 
#

set -- "$COUNT" 
IFS=" "; declare -a Array=($*) 
echo "${Array[" "]}"

echo "========== Number unique user in each day ==========="

for((i=1; i<=END;i++))
do
	if [ $FPATH"result"$i".log.gz" ]; then
		# set to temp
		
		zcat $FPATH"result"$i".log.gz" > $FPATH"temp.log"
		
		numbUser=$(wc -l $FPATH"temp.log")
		
		set -- "$numbUser" 
		IFS=" "; declare -a Array=($*) 
		
		echo "Day 0"$i " : " "${Array[" "]}" " user"
	fi
done

echo "========== Number unique user in each region ==========="

echo $(cut -f 2- $FPATH"logs.log" | sort | uniq) > $FPATH"logs_temp.log"
COUNTRY=$(cut -f 2 $FPATH"logs_temp.log" | sort | uniq)

echo $COUNTRY > $FPATH"logs_temp.log"

#
# Fetch data string to array
#
index=0
while read line ; do
    MYARRAY[$index]="$line"
    index=$(($index+1))
done < $FPATH"logs_temp.log"

#
# show array data
#
for each in "${MYARRAY[@]}"
do
	num=$(grep -o $each $FPATH"logs.log" | wc -l)
  	echo $each " : " $num " users"; 
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"