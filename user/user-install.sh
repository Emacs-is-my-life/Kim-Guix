#!/bin/sh

mkdir .temp
echo "Please enter your gmail address:"
read USER_GMAIL_ADDRESS
cat ./files/isyncrc.template \
    | sed "s|{{ USER_GMAIL_ADDRESS }}|$USER_GMAIL_ADDRESS|g" \
> ./.temp/isyncrc

export USER_FULL_NAME=$(getent passwd $(whoami) | cut -d':' -f5)

mkdir -p ~/.config/guix
cp ./files.channels.scm ~/.config/guix/

# Keep trying
while true; do
	guix pull -C ./files/channels.scm && \
	guix home reconfigure ./home-config.scm && \
	break

	sleep 60
done

echo "export USER_MAIL_ADDRESS='${USER_GMAIL_ADDRESS}'" > ~/Documents/Secrets/userinfo.env
echo "export USER_FULL_NAME='${USER_FULL_NAME}'" >> ~/Documents/Secrets/userinfo.env

# Install Guix profiles
export GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
mkdir -p $GUIX_EXTRA_PROFILES

regex="^guix-(.+)-manifest.scm$"
for f in $(ls ./guix-manifests)
do
        if [[ $f =~ $regex ]]
        then
            PROFILE_NAME="${BASH_REMATCH[1]}"
            mkdir -p "$GUIX_EXTRA_PROFILES"/guix-${PROFILE_NAME}-profile
            guix package --manifest=./guix-manifests/guix-${PROFILE_NAME}-manifest.scm \
                 --profile="$GUIX_EXTRA_PROFILES"/guix-${PROFILE_NAME}-profile/guix-${PROFILE_NAME}-profile
        fi
done

# Install pip packages
pip3 install -r ./files/requirements.txt
pip3 uninstall -y numpy

# Directory permission
chmod -R 711 ~/Documents
chmod -R 711 ~/Workspace

rm -rf ./.temp

if [ "$(pwd)" != "$HOME/Documents/Guix/user" ]; then
    cp -r ../../Guix $HOME/Documents/
fi

echo "Installation is complete."
echo '!! Check examples/authinfo !!'
echo ""
echo "Fill out authinfo file accordingly to use email and gpt service"
echo 'Then place your GPG encrypted authinfo file as: ~/Documents/Secrets/authinfo.gpg'
