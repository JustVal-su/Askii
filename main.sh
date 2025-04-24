#!/bin/bash

# echo 'Welcome to askii!'
# echo "Seems like you do not have any model configured."
# echo "Try typing help if you do not know what to do."

source .env

LIST_FILE="./list.txt"

if [ ! -f "./list.txt" ] ; then
	echo "    NAME        MODEL                          PROVIDER       STREAM " >> list.txt
else
	echo "already created"
fi

if [ "$1" == '--help' ] ; then
	echo "Askii is a cli app to interact with llm."
	echo "You can add one model with askii -add."
	echo "With -get, you will see a tutorial to learn how to get free AI api keys."
	echo "If you want audio answers, type askii -sound"
elif [ "$1" == '-add' ] ; then
	read -p "You want to use your model with [OpenRouter]: " answer
	case "$answer" in
		"OpenRouter" | "openrouter" ) read -p 'With wich model ? (type "man" for a manual installation): ' model ;;
	esac
		if [ "$model" == 'man' ] ; then
			echo "manInstall"
		fi
elif [ $# -eq 0 ] ; then
	echo 'Welcome to askii!'
	echo "Type "--help" if you do not know what to do."
	
elif [ "$1" == '-get' ] ; then
	echo "A little tuto to learn how to get free ai api key with OpenRouter. Start by creating an OpenRouter account at https://www.openrouter.ai/ (or login if you have already created one). Once you do it, navigate to the API section on the dashboard. Click on create key button. This will generate your api key. Save it in a secure location, you won't able to see it again ! You will need it when you use a model. After, you will have to paste your api key when you will add a model." > orTextbox
	whiptail --textbox orTextbox 15 70

elif [ "$1" == '-sound' ] ; then
	read -p 'Want to enable sound answer? [Y/n]: ' activateSound
	
	case "$activateSound" in
    		[yY]|[yY])
       			sed -i 's/^SOUND=.*/SOUND=true/' .env
        	;;
        	[nN]|[nN])
        		sed -i 's/^SOUND=.*/SOUND=false/' .env
        	;;
    		*)
        		echo "Bad input. Not executed"
        		exit
        	;;
	esac
	
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
	
exit
