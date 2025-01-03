#!/bin/sh

mkdir .temp
echo "Please enter your gmail address:"
read USER_GMAIL_ADDRESS
cat ./files/isyncrc.template \
    | sed "s|{{ USER_GMAIL_ADDRESS }}|$USER_GMAIL_ADDRESS|g" \
> ./.temp/isyncrc

echo "Please enter your full name:"
read USER_FULL_NAME

# Keep trying
while true; do
	guix pull -C ./files/channels.scm && \
	guix home reconfigure ./home-config.scm && \
	break

	sleep 60
done

echo "export USER_MAIL_ADDRESS='${USER_GMAIL_ADDRESS}'" > ~/Documents/Secrets/userinfo.env
echo "export USER_FULL_NAME='${USER_FULL_NAME}'" >> ~/Documents/Secrets/userinfo.env

# Install pip packages
pip3 install -r ./files/requirements.txt

# Directory permission
chmod -R 711 ~/Documents
chmod -R 711 ~/Workspace

rm -rf ./.temp

if [ "$(pwd)" != "$HOME/Documents/Guix/user" ]; then
    cp -r ../../Guix $HOME/Documents/
fi

echo 'Check "examples/authinfo"'
echo ""
echo 'Then place your GPG encrypted authinfo file at: "~/Documents/Secrets/authinfo.gpg"'
