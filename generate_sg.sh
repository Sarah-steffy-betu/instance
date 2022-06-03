#!/bin/bash

I=0

while read line
do
	if [ $I -gt 0 ]
	then
		if [ ! -z $line ]
		then
			SG_NAME=$(echo $line | cut -d";" -f1)
			PORT=$(echo $line | cut -d";" -f2)

			FROM_PORT=$(echo $PORT | cut -d"-" -f1)
			TO_PORT=$(echo $PORT | cut -d"-" -f2)

			if [ -z $TO_PORT ]
			then
				TO_PORT=$FROM_PORT
			fi

			PROTOCOL=$(echo $line | cut -d";" -f3)
			TYPE=$(echo $line | cut -d";" -f4)
			SOURCE=$(echo $line | cut -d";" -f5)

			cp ingress_template new_ingress

			sed -i "s|<##FROM_PORT##>|${FROM_PORT}|g" new_ingress
			sed -i "s|<##TO_PORT##>|${TO_PORT}|g" new_ingress
			sed -i "s|<##PROTOCOL##>|${PROTOCOL}|g" new_ingress

			if [ "$TYPE" == "SG" ]
			then
				SG_TYPE="security_groups"
				SG_TEMPLATE="\$\{aws_security_group.${SOURCE}.id\}"
			else
				SG_TYPE="cidr_blocks"
				SG_TEMPLATE="${SOURCE}"
			fi


			sed -i "s|<##SG_TYPE##>|${SG_TYPE}|g" new_ingress
			sed -i "s|<##SG_TEMPLATE##>|${SG_TEMPLATE}|g" new_ingress

			cat new_ingress >> ${SG_NAME}.ingress
			echo "" >> ${SG_NAME}.ingress
			rm new_ingress
		fi
	else
		I=1
	fi
done < flow_matrix

for SGROUP in $(ls *.ingress)
do
	
	GROUP_NAME=$(echo $SGROUP | cut -d"." -f1)
	#GROUP_NAME=$(echo $SG_NAME| cut -d"." -f1)
	
	mkdir GENERATED
	
	GEN_FILE="GENERATED/${GROUP_NAME}.tf"
	cp security_group_template $GEN_FILE

	sed -i "s|<##SG_NAME##>|${GROUP_NAME}|g" $GEN_FILE

	LTOWRITE=$(cat -n ${GEN_FILE} | grep "<##INGRESS_RULES##>" | sed 's|\t| |g' | tr -s " " | cut -d" " -f2)

	sed -i "${LTOWRITE} r ${SGROUP}" $GEN_FILE
	sed -i "s|<##INGRESS_RULES##>||g" $GEN_FILE

	rm $SGROUP
done
git clone <##GIT_URL##>
