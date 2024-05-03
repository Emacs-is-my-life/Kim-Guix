#!/bin/sh

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
