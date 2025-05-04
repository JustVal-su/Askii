#!/bin/bash

read -p "Put your OpenRouter api key: " apikey
read -p "Set a name: " name
if grep -q "^$name=" .env; then
    echo "This name is alreadu choosen. Please pick another one."
else
    echo "$name=$apikey" >> .env
fi