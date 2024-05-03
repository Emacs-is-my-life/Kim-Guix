#!/bin/sh

# Keep trying
while true; do
	guix pull -C ./files/channels.scm && \
	guix home reconfigure ./home-config.scm && \
	break

	sleep 60
done

if [ "$(pwd)" != "$HOME/Documents/Guix/user" ]; then
    cp -r ../../Guix $HOME/Documents/
fi
