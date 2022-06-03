#!/bin/bash

I=0

while read line
do
	if [ $I -gt 0 ]
	then
		if [ ! -z $line ]
		then
			INSTANCE_NAME=$(echo $line | cut -d";" -f1)
			SUBNET_NAME=$(echo $line | cut -d";" -f2)
			USER_DATA=$(echo $line | cut -d";" -f3)
			SGROUP=$(echo $line | cut -d";" -f4)
			PUBIP=$(echo $line | cut -d";" -f5)

			cp instance_template new_instance

			sed -i "s|<##INSTANCE_NAME##>|${INSTANCE_NAME}|g" new_instance
			sed -i "s|<##SUBNET_ID##>|${SUBNET_NAME}|g" new_instance
			sed -i "s|<##USER_DATA##>|${USER_DATA}|g" new_instance
			sed -i "s|<##SECURITY_GROUP##>|${SGROUP}|g" new_instance
			sed -i "s|<##PUBLIC_IP##>|${PUBIP}|g" new_instance

			mv new_instance ${INSTANCE_NAME}.tfpart
		fi
	else
		I=1
	fi
done < instances_matrix

cat *.tfpart > instances.tf
rm *.tfpart
