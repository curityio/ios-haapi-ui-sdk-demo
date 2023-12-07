#!/bin/bash

####################################################################################################
# Run the Curity Identity Server in Docker on the local computer, preconfigured for the code example
# Please ensure that the following resources are installed before running this script:
# - Docker Desktop
# - The envsubst tool (`brew install gettext` on MacOS)
#
# If you want to expose the local instance of the Curity Identity Server via ngrok, then the following
# need to also be installed:
# - ngrok
# - The jq tool (`brew install jq` on MacOS)
####################################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# By default the Curity Identity Server will use the local computer's host IP.
# Set USE_NGROK to true and a dynamic NGROK base URL will be used automatically.
#
USE_NGROK='true'
BASE_URL='https://localhost:8443'
EXAMPLE_NAME='haapi'

#
# If using passkey logins, override the team ID to match your setup
#
if [ "$APPLE_TEAM_ID" == '' ]; then
  export APPLE_TEAM_ID='MYTEAMID'
fi
if [ "$APPLE_APP_ID" == '' ]; then
  export APPLE_APP_ID='io.curity.haapidemo'
fi

#
# First check prerequisites
#
if [ ! -f './license.json' ]; then
  echo 'Please copy a license.json file into the root folder of the code example'
  exit 1
fi

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

export APPLE_TEAM_ID='U3VTCHYEM7'

#
# Run the deployment script to get an NGROK URL and deploy the Curity Identity Server
#
cp ./license.json deployment/resources/license.json
./deployment/start.sh "$USE_NGROK" "$BASE_URL" "$EXAMPLE_NAME"
if [ $? -ne 0 ]; then
  echo 'Problem encountered deploying the Curity Identity Server'
  exit
fi

#
# Inform the user of the Curity Identity Server URL, to be copied to configuration
#
RUNTIME_BASE_URL=$(cat './deployment/output.txt')
echo "Curity Identity Server is running at $RUNTIME_BASE_URL"

#
# Update URLs referenced in the code example to match NGROK
#
function replaceTextInFile() {

  FROM="$1"
  TO="$2"
  FILE="$3"
  
  if [ "$(uname -s)" == 'Darwin' ]; then
    sed -i '' "s/$FROM/$TO/g" "$FILE"
  else
    sed -i -e "s/$FROM/$TO/g" "$FILE"
  fi
}

if [ "$USE_NGROK" == 'true' ]; then
  DEFAULT_URL=${BASE_URL//\//\\/}
  RUNTIME_BASE_URL=${RUNTIME_BASE_URL//\//\\/}
  replaceTextInFile $DEFAULT_URL $RUNTIME_BASE_URL './src/Configuration.swift'
fi
