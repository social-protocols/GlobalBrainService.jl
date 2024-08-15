#!/usr/bin/env bash
set -Eeuo pipefail

curl \
	--silent \
	--fail \
	--header "Content-Type: application/json" \
	--data '[{"user_id":"105","parent_id":null,"post_id":1,"vote":1,"vote_event_time":1708772663570,"vote_event_id":6}]' \
	http://127.0.0.1:8000/score
