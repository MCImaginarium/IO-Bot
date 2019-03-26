#!/bin/bash
cd "$(dirname "$0")"
DISCORD_TOKEN=$(cat ~/.discord_token)
MYSQL_DATABASE=$(cat ~/.mysql_database)
MYSQL_USER=$(cat ~/.mysql_username)
MYSQL_PASSWORD=$(cat ~/.mysql_password)
MYSQL_HOST=$(cat ~/.mysql_hostname)
MCR_PASS=$(cat ~/.mcr_password)
YOUTUBE_KEY=$(cat ~/.youtube_key)
GOOGLE_URL=$(cat ~/.google_url)
MONGO=$(cat ~/.mongo)
cd "$(dirname "$0")"
if ! screen -list | grep -q "bot"; then
	echo "Bot was not started, starting in background!"
	cd /storage/bot/
	rm /storage/bot/config.json
	rm /storage/bot/tps.sh
	sed "s#MCR_PASS#$MCR_PASS#g" /storage/bot/tps.sh.template > /storage/bot/tps.sh;
	sed "s#DISCORD_TOKEN#$DISCORD_TOKEN#g" /storage/bot/config.json.template > /storage/bot/config.json;
	sed -i "s/MYSQL_USERNAME/$MYSQL_USERNAME/g" /storage/bot/config.json;
	sed -i "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/g" /storage/bot/config.json;
	sed -i "s/MYSQL_HOSTNAME/$MYSQL_HOSTNAME/g" /storage/bot/config.json;
	sed -i "s/MYSQL_DATABASE/$MYSQL_DATABASE/g" /storage/bot/config.json;
	sed -i "s/YOUTUBE_KEY/$YOUTUBE_KEY/g" /storage/bot/config.json;
	sed -i "s/GOOGLE_URL/$GOOGLE_URL/g" /storage/bot/config.json;
	git stash;
	git pull;
	#npm update;
        screen -LdmS bot node /storage/bot/bot.js
else
	echo "Bot is already started, not starting!"
fi

if ! screen -list | grep -q "radio"; then
	echo "Radio Bot was not started, starting in background!"
        screen -LdmS radio /usr/bin/ices -c /storage/radio.xml
else
	echo "Radio Bot is already started, not starting!"
fi
