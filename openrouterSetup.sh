#!/bin/bash

read -p "Put your OpenRouter api key: " apikey
read -p "Set a name: " name
if grep -q "^$name=" .env; then
    echo "This name is already choosen. Please pick another one."
else
    echo "$name=$apikey" >> .env
    echo "If you want to make this api key the default, type ./main.sh -settings"
fi