#!/bin/sh
docker compose create ide
docker compose cp ~/.ssh/id_rsa ide:/home/ideuser/.ssh
docker compose cp ~/.ssh/id_rsa.pub ide:/home/ideuser/.ssh
docker compose up -d
