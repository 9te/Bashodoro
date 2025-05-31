#!/bin/bash
echo "to enter time, use 'number + s|m|h' (e.g: 10s for 10 seconds, 10m for 10 minutes, and 10h for 10 hours)"
read -p "Study time: " INPUT_ST

while [ ${INPUT_ST:${#INPUT_ST}-1:1} != "m" ] && [ ${INPUT_ST:${#INPUT_ST}-1:1} != "h" ] && [ ${INPUT_ST:${#INPUT_ST}-1:1} != "s" ]; do
	read -p "(Enter with right formatting) Study time: " INPUT_ST
done

read -p "Break time: " INPUT_BT

while [ ${INPUT_BT:${#INPUT_BT}-1:1} != "m" ] && [ ${INPUT_BT:${#INPUT_BT}-1:1} != "h" ] && [ ${INPUT_BT:${#INPUT_BT}-1:1} != "s" ]; do
	read -p "(Enter with right formatting) Break time: " INPUT_BT
done

ST=${INPUT_ST:0:${#INPUT_ST}-1}
ST_UNIT=${INPUT_ST:${#INPUT_ST}-1:1}

if [[ $ST_UNIT == "m" ]]; then
	ST=`echo "$ST * 60" | bc`
elif [[ $ST_UNIT == "h" ]]; then
	ST=`echo "$ST * 3600" | bc`
	echo $ST
fi

BT=${INPUT_BT:0:${#INPUT_BT}-1}
BT_UNIT=${INPUT_BT:${#INPUT_BT}-1:1}
if [[ $BT_UNIT == "m" ]]; then
	BT=`echo "$BT * 60" | bc`
elif [[ $BT_UNIT == "h" ]]; then
	BT=`echo "$BT * 3600" | bc`
fi


ST=${ST/\.*/}
BT=${BT/\.*/}


function break_timer () {
	COUNTER=$BT
	clear 
	echo "· • —– ٠ Break Timer ٠ —– • ·"
	date -d@$COUNTER -u +%H:%M:%S
	while [ $COUNTER -gt 0 ]; do
		sleep 1
		COUNTER=$((--COUNTER))
		clear
		echo "· • —– ٠ Break Timer ٠ —– • ·"
		date -d@$COUNTER -u +%H:%M:%S
	done
	mpg123 Timer.mp3
	clear
	notify-send " Time to study again"
	read -p "Press Enter to start studies ... (type 'exit' to exit the application)" USERINPUT
	if [ $USERINPUT == "exit" ]; then
		echo "bye bye"
		exit
	else
		break_timer
	fi
}

function study_timer () {
	COUNTER=$ST
	clear 
	echo "· • —– ٠ Study Timer ٠ —– • ·"
	date -d@$COUNTER -u +%H:%M:%S
	while [ $COUNTER -gt 0 ]; do
		sleep 1
		COUNTER=$((--COUNTER))
		clear
		echo "· • —– ٠ Study Timer ٠ —– • ·"
		date -d@$COUNTER -u +%H:%M:%S
	done
	mpg123 Timer.mp3
	clear
	notify-send " Time to take a break"
	read -p "Press Enter to start break... (type 'exit' to exit the application)" USERINPUT
	
	if [ $USERINPUT == "exit" ]; then
		echo "bye bye"
		exit
	else
		break_timer
	fi
	
	
	
}

study_timer
