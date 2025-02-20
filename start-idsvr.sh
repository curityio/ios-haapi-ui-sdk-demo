#!/bin/bash

####################################################################################################
# A developer deployment to run the Curity Identity Server in Docker on the local computer.
# The deployment provides a working configuration and includes native passkeys automation.
# - https://curity.io/resources/learn/mobile-logins-using-native-passkeys/
####################################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# First check for a license
#
if [ ! -f './license.json' ]; then
  echo 'Please copy a license.json file into the root folder of the code example'
  exit 1
fi

#
# Then validate or default parameters
#
EXAMPLE_NAME='haapi'
if [ "$USE_NGROK" != 'true' ]; then
  USE_NGROK='false'
  if [ "$IDSVR_HOST_NAME" == '' ]; then
    echo 'You must supply an IDSVR_HOST_NAME for the Curity Identity Server'
    exit 1
  fi
fi

#
# Download mobile deployment resources
#
rm -rf deployment
git clone https://github.com/curityio/mobile-deployments deployment
if [ $? -ne 0 ]; then
  echo 'Problem encountered downloading deployment resources'
  exit 1
fi

#
# TODO: delete before merging
#
cd deployment
git checkout feature/sdk_update
cd ..

#
# To test passkeys on iOS, override these settings with a Team ID that you own and your own unique bundle ID
#
if [ "$APPLE_TEAM_ID" == '' ]; then
  export APPLE_TEAM_ID='MYTEAMID'
fi
if [ "$APPLE_BUNDLE_ID" == '' ]; then
  export APPLE_BUNDLE_ID='io.curity.haapidemo'
fi

#
# Set working options for the HAAPI Android App, which can be run alongside the iOS App against the same backend
#
export ANDROID_PACKAGE_NAME='io.curity.haapidemo'
export ANDROID_SIGNATURE_DIGEST='Z2DKEZO2XWFWQnApoRCzhqhIxzODe7BUsArj4Up9oKQ='
export ANDROID_FINGERPRINT='67:60:CA:11:93:B6:5D:61:56:42:70:29:A1:10:B3:86:A8:48:C7:33:83:7B:B0:54:B0:0A:E3:E1:4A:7D:A0:A4'

#
# To test passkeys on iOS, override these settings with a Team ID that you own and your own unique bundle ID
#
if [ "$APPLE_TEAM_ID" == '' ]; then
  export APPLE_TEAM_ID='MYTEAMID'
fi
if [ "$APPLE_BUNDLE_ID" == '' ]; then
  export APPLE_BUNDLE_ID='io.curity.haapi.react.example'
fi

#
# Run an automated deployment of the Curity Identity Server
#
cp ./license.json deployment/resources/license.json
if [ "$USE_NGROK" == 'true' ]; then
  ./deployment/start.sh 'true' '-' "$EXAMPLE_NAME"
else
  ./deployment/start.sh 'false' "https://$IDSVR_HOST_NAME:8443" "$EXAMPLE_NAME"
fi
if [ $? -ne 0 ]; then
  echo 'Problem encountered deploying the Curity Identity Server'
  exit 1
fi

#
# Get the final Curity Identity Server URL
#
export IDSVR_BASE_URL="$(cat ./deployment/output.txt)"
echo "Curity Identity Server is running at $IDSVR_BASE_URL"

#
# Configure the iOS app to use the Curity Identity Server's base URL
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

IDSVR_HOST_NAME="${IDSVR_BASE_URL#https://}"
replaceTextInFile 'localhost:8443' "$IDSVR_HOST_NAME" './src/Configuration.swift'
if [ "$USE_NGROK" == 'true' ]; then
  replaceTextInFile 'localhost:8443' "$IDSVR_HOST_NAME" './haapidemo.entitlements'
fi
