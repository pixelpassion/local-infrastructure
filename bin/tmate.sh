#!/bin/bash

set -e

if tmate -V; then
    echo ""
else
    printf 'tmate seems not to be installed, please install. On MacOS `brew install tmate`\n'
    exit 1
fi

eval $(egrep -v '^#' .env | xargs)

if [ -z $SLACK_WEBHOOK_URL ]; then echo "SLACK_WEBHOOK_URL is unset or empty, plesase add it to your .env"; exit 1; fi

read -p "To whom should it be send? " CHANNEL

DEFAULT_EMOJI=:slack:
AUTHOR="Tmate Bot"

tmate -S /tmp/tmate.sock new-session -d && tmate -S /tmp/tmate.sock wait tmate-ready
TMATE_URL=`tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'`

PAYLOAD='payload={"channel": "@'$CHANNEL'", "username": "'$AUTHOR'", "text": "`'$TMATE_URL'`", "icon_emoji": "'$DEFAULT_EMOJI'"}'

curl -sS -o /dev/null -X POST --data-urlencode  "$PAYLOAD" $SLACK_WEBHOOK_URL

tmate -S /tmp/tmate.sock attach

PAYLOAD='payload={"channel": "@'$CHANNEL'", "username": "'$AUTHOR'", "text": "`Tmate connection closed.`", "icon_emoji": "'$DEFAULT_EMOJI'"}'

curl -sS -o /dev/null -X POST --data-urlencode  "$PAYLOAD" $SLACK_WEBHOOK_URL
