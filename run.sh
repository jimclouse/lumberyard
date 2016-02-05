#!/bin/bash
logEntry=$1
# set -e
echo got input $logEntry

# if grep -q lumber: <<<$logEntry; then
# 	echo "@@@@@@@" Found Lumber: $logEntry;
# 	IFS='lumber:' read -r id string <<< "$logEntry"
# 	echo id: $id
# 	echo string: $string
# else
# 	echo Regular Log Line: $logEntry;
# fi;
# echo


if [[ "$logEntry" =~ lumber:[[:space:]]{.*:[[:space:]]{.*}} ]]
then

	INSERT='INSERT INTO '
	COLUMNS=''
	VALUES=''

	echo Looks like lumber
	line=${BASH_REMATCH[0]}
	line=${line%\}}
	line=${line/#lumber: \{/}
	cols=${line#*:}
	cols=${cols%\}}
	cols=${cols#*\{}
	table=${line%%:*}

	# awk '{
	#  for (i = 0; ++i <= NF;) {
	#    substr($i, 1, 1) == "\"" &&
	#      $i = substr($i, 2, length($i) - 2)
	#    printf "[%s]%s", $i, (i < NF ? OFS : RS)
	#     }
	#  }' FPAT='([^,]*)|("[^"]+")' <<< $cols

	IFS=',' read -ra array <<< "$cols"

	for i in "${array[@]}"; do
		col=${i%%:*}
		col=${col## }
		col=${col%% }
		val=${i#*:}
		val=${val## }
		val=${val%% }
		COLUMNS="$COLUMNS, $col"
		VALUES="$VALUES, '$val'"
	done

	COLUMNS=${COLUMNS#*,}
	VALUES=${VALUES#*,}
	INSERT="$INSERT $table ($COLUMNS) VALUES ($VALUES)"

	echo $INSERT

	echo osql -S $LUMBERYARD_SERVER -U $LUMBERYARD_USER -P $LUMBERYARD_PASSWORD -q \"$INSERT\"
	osql -S $LUMBERYARD_SERVER -U $LUMBERYARD_USER -P $LUMBERYARD_PASSWORD -q \"$INSERT\"
else
	echo "Nothing"
fi

echo
echo