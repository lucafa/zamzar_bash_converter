#!/bin/bash

#VARIABLES
WORK_DIR="@/home/speedy/"
JSON_DIR="/home/speedy/"
TARGET_FORMAT="jpg"
KEY_ZAMZAR="934c8a4e246a0a81b6232323rcd61b8bf2cc5:"

#MAIN
for i in `ls  *.dwg` 
do 
curl https://sandbox.zamzar.com/v1/jobs -u $KEY_ZAMZAR -X POST  -F  "source_file=$WORK_DIR$i" -F "target_format=$TARGET_FORMAT" > $i.json
id_work=`cat $i.json | grep key | awk -F":" '{print $2}' | awk -F"," '{print $1}'`

curl https://sandbox.zamzar.com/v1/jobs/$id_work  -u $KEY_ZAMZAR > identifier.json
sleep 5
for ((c=1; c<30;c++))
	do
	status=`cat identifier.json  | grep null`
		if [[ -n $status ]];then
			sleep 5
			curl https://sandbox.zamzar.com/v1/jobs/$id_work  -u $KEY_ZAMZAR > identifier.json
		else 
			c=1500
		fi
done

id_download=`cat identifier.json |  awk -F'"target_files":' '{print $2}' | awk -F"id" '{print $2}'  | awk -F'":' '{print $2}' | awk -F"," '{print $1}'`
nome_file=`cat identifier.json  | awk -F'"target_files":' '{print $2}' | awk -F"name" '{print $2}'  | awk -F'":' '{print $2}' | awk -F"," '{print $1}' | awk -F'"' '{print $2}'`

#DOWNLOAD TARGET FILE
curl https://sandbox.zamzar.com/v1/files/$id_download/content -u $KEY_ZAMZAR -L -O -J

rm  $JSON_DIR*.json
done

