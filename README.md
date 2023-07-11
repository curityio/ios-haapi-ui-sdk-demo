# Demo iOS Application with HAAPI UI SDK Integration

This is an example iOS app that uses the Curity Identity Server's Hypermedia API to perform an OIDC flow. The authentication is done within the app, usually without the need for an external browser (depends on the authentication methods used).

## Pre-Release Build Instructions

Until the SDK is released, Curity employees can build this app via the following steps:

- Build the pre-release frameworks according to [these instructions](https://stackoverflowteams.com/c/curity/questions/194)
- Drag the `build/IdsvrHaapiUIKit.xcframework` into the `Frameworks` folder

## Docker Automated Setup

The required Curity Identity Server setup is provided through a script. To run the setup, follow these steps:

1. Copy a Curity Identity Server license file to `license.json` in the code example root folder.
2. Run the `./start-idsvr.sh` script to deploy a preconfigured Curity Identity Server via Docker. 
3. Build and run the mobile app from Xcode using an emulator of your choice.
4. There is a preconfigured user account you can sign-in with: demouser / Password1. Feel free to create additional accounts.
5. Run the `./stop-idsvr.sh` script to free Docker resources.

By default the Curity Identity Server instance runs on the the iOS emulator's default host IP. 
If you prefer to expose the Server on the Internet (e.g. to test with a real device), you can use the 
ngrok tool for that. Edit the `USE_NGROK` variable in `start-server.sh` and `stop-server.sh` scripts.
Then change the configuration setting `useSSL` to true, as ngrok provides trusted certificates for the connection.

This [Mobile Setup](https://curity.io/resources/learn/mobile-setup-ngrok/) tutorial further describes
this option.
