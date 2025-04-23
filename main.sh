#!/bin/bash

# echo 'Welcome to askii!'
# echo "Seems like you do not have any model configured."
# echo "Try typing help if you do not know what to do."

source .env

if [ "$1" == '--help' ] ; then
	echo "Askii is a cli app to interact with llm."
	echo "You can add one model with askii -add."
	echo "With -get, you will see a tutorial to learn how to get free AI api keys."
elif [ "$1" == '-add' ] ; then
	read -p "You want to use your model with [OpenRouter]:" answer
	case "$answer" in
		"OpenRouter" | "openrouter" ) read -p 'With wich model ? (type "man" for a manual installation): ' model ;;
	esac
		if [ "$model" == 'man' ] ; then
			echo "manInstall"
		fi
else
	object=$(jq -n --arg content "$*" '{
	model: "deepseek/deepseek-chat:free",
	messages: [
    {role: "system", content: "You are a helpful assistant."},
    {role: "user", content: $content}
  ]
}')
	
	
	curl https://openrouter.ai/api/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer $OPENROUTER_API_KEY"   -d "$object" | jq -r '.choices[0].message.content'

	
fi

#utile : pour compter combien de lettres on été reçus, ${#var}

if [ "$1" == '-get' ] ; then
	echo "A little tuto to learn how to get free ai api key with OpenRouter" > orTextbox
	whiptail --textbox orTextbox 12 80
fi
	
exit
