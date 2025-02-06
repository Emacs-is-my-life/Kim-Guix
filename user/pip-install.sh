#!/bin/sh

# Install pip packages
pip3 install -r ./files/requirements.txt
pip3 uninstall -y numpy
