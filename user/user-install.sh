#!/bin/sh

mkdir .temp
echo "Please enter your gmail address:"
read USER_GMAIL_ADDRESS
cat ./files/isyncrc.template \
    | sed "s|{{ USER_GMAIL_ADDRESS }}|$USER_GMAIL_ADDRESS|g" \
> ./.temp/isyncrc

export USER_FULL_NAME=$(cat /etc/passwd | grep $(whoami) | cut -d':' -f5)

mkdir -p ~/.config/guix
cp ./files/channels.scm ~/.config/guix/

# Keep trying
while true; do
	guix pull -C ./files/channels.scm && \
	guix home reconfigure ./home-config.scm && \
	break

	sleep 60
done

mkdir -p ~/Documents/Secrets
echo "export USER_MAIL_ADDRESS='${USER_GMAIL_ADDRESS}'" > ~/Documents/Secrets/userinfo.env
echo "export USER_FULL_NAME='${USER_FULL_NAME}'" >> ~/Documents/Secrets/userinfo.env

# Initialize mu mail utility
mkdir -p ~/Documents/Mail
mu init --maildir ~/Documents/Mail --my-address="$USER_GMAIL_ADDRESS"

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


# Directory permission
mkdir -p ~/Documents
mkdir -p ~/Workspace
chmod 700 ~/Documents
chmod 700 ~/Workspace

# Org
mkdir -p ~/Documents/Org/notes
mkdir -p ~/Documents/Org/agenda
touch ~/Documents/Org/notes/default.org
touch ~/Documents/Org/notes/contacts.org

# Install Python Packages to Default Environment
hash guix
export PYTHON_DEFAULT_DIR=$HOME/.python-venv/Default
if [ ! -d $PYTHON_DEFAULT_DIR ]; then
    uv venv $PYTHON_DEFAULT_DIR
fi
source $PYTHON_DEFAULT_DIR/bin/activate
uv pip install -r ./python-venv/Default.txt


rm -rf ./.temp

if [ "$(pwd)" != "$HOME/Documents/Guix/user" ]; then
    cp -r ../../Guix $HOME/Documents/Guix
fi

echo "Installation is complete."
echo '!! Check examples/authinfo !!'
echo ""
echo "Fill out authinfo file accordingly to use email and gpt service"
echo 'Then place your GPG encrypted authinfo file as: ~/Documents/Secrets/authinfo.gpg'
