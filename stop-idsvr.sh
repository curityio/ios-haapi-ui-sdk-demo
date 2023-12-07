#!/bin/bash

###############################################################
# Free deployment resources when finished with the code example
###############################################################

USE_NGROK='true'
EXAMPLE_NAME='haapi'

#
# Download mobile deployment resources
#
rm -rf deployment
git clone https://github.com/curityio/mobile-deployments deployment
if [ $? -ne 0 ]; then
  echo 'Problem encountered downloading deployment resources'
  exit
fi

#
# TODO: delete after merge
#
cd deployment
git checkout feature/passkeys
cd ..

#
# Do the teardown
#
./deployment/stop.sh "$USE_NGROK" "$EXAMPLE_NAME"
