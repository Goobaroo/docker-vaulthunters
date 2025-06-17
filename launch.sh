#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f VaultHunters-OfficialModpack-1.12.1-Server.zip ]]; then
  rm -fr config defaultconfigs scripts forge-*.jar start.sh *Server.zip
	curl -Lo VaultHunters-OfficialModpack-1.12.1-Server.zip 'https://edge.forgecdn.net/files/3602/5/VaultHunters-OfficialModpack-1.12.1-Server.zip' && unzip -u -o 'VaultHunters-OfficialModpack-1.12.1-Server.zip' -d /data
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

if [[ -f start.sh ]]; then
  chmod +x start.sh
  ./start.sh
else
  FORGE_JAR=$(ls forge-*.jar)
  java -server -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Dfml.queryResult=confirm $JAVA_OPTS -jar $FORGE_JAR nogui
fi