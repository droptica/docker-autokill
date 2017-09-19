#!/usr/bin/env sh

while true
do
    for I in `docker ps -aq`
    do
        KILL_TIME=''
        eval `docker inspect -f  '{{range $index, $value := .Config.Env}}{{println $value}}{{end}}'  $I | grep KILL_TIME`
        if [ -n "$KILL_TIME" ]; then
            NOW=$(date +%s)
            if [ "$NOW" -gt "$KILL_TIME" ]; then
                CONTAINER_NAME=`docker inspect --format='{{.Name}}' $I`
                CONTAINER_IMAGE=`docker inspect --format='{{.Config.Image}}' $I`
                echo "`date +\"%Y-%m-%d %H:%M:%S\"` Killing: Container ID: '$I', Name: '$CONTAINER_NAME', Image: '$CONTAINER_IMAGE'"
                docker stop $I > /dev/null
                docker rm -f $I > /dev/null
            fi
        fi
    done
    echo "sleeping"
    sleep $(($WAIT*60))
done


