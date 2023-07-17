# Demo iOS Application with HAAPI UI SDK Integration

This is an example iOS app that uses the Curity Identity Server's Hypermedia API to perform an OIDC flow. The authentication is done within the app, usually without the need for an external browser (depends on the authentication methods used).

## Pre-Release Build Instructions

Until the SDK is released, Curity employees can build this app via the following steps:

- Build the pre-release frameworks according to [these instructions](https://stackoverflowteams.com/c/curity/questions/194)
- Drag the `build/IdsvrHaapiUIKit.xcframework` into the `Frameworks` folder

To avoid `DYLD1 library missing` errors using the launch icon on a simulator I use the `Embed and Sign` option.\
I'm also using automatic signing with my personal Apple account.

## Code Organization

This is a trivial app that only authenticates the user, then displays the tokens obtained from the authorization server. Some source files worth checking out:

- The `Configuration` object contains all of the OpenID Connect settings. You should tailor these to reflect your installation of the Curity Identity Server.
- The `DemoAppDelegate` shows how to configure the HAAPI UI SDK so that it can be used with the app.
- The `UnauthenticatedView` shows the code needed to integrate with the HAAPI UI SDK. The `HaapiFlow.start` operations is invoked and a callback receives tokens once the authentication workflow completes.
- The `AuthenticatedView` class shows how to handle other lifecycle events once the user is authenticated. This displays the received tokens and obtains information about the user from the user info endpoint. It also shows how to manage token refresh and logout.

## Getting started

### Docker Automated Setup

The required Curity Identity Server setup is provided through a script. To run the setup, follow these steps:

1. Copy a Curity Identity Server license file to `license.json` in the code example root folder.
2. Run the `./start-idsvr.sh` script to deploy a preconfigured Curity Identity Server via Docker. 
3. Build and run the mobile app from Xcode using a simulator of your choice.
4. There is a preconfigured user account you can sign-in with: demouser / Password1. Feel free to create additional accounts.
5. Run the `./stop-idsvr.sh` script to free Docker resources.

By default the Curity Identity Server instance runs on a localhost URL. 
If you prefer to expose the Server on the Internet (e.g. to test with a real device), you can use the 
ngrok tool for that. Edit the `USE_NGROK` variable in `start-server.sh` and `stop-server.sh` scripts.
This [Mobile Setup](https://curity.io/resources/learn/mobile-setup-ngrok/) tutorial further describes
this option.

## Running the App

### Simulator

1. Make sure that the Curity Identity Server is running and configured.
2. Start the demo application on a simulator running iOS 14 or higger
3. Tap the button `Start Authentication` on the home screen to start the authentication flow.

### Physical Device

1. Make sure that the Curity Identity Server is running and reachable on the Internet (e.g., by using [ngrok](https://curity.io/resources/learn/expose-local-curity-ngrok/)).
2. Adjust the settings in the `Configuration` module to reflect the instance of your Curity Identity Server.
3. Build then install and start the demo application on your physical device.
4. Tap the button `Start Authentication` on the home screen to start the authentication flow.

## Configuring the App

The application needs a few configuration options set to be able to call the instance of the Curity Identity Server. Default configuration is set to work with the dockerized version of the Curity Identity Server which is run with the `start-idsvr.sh` script. Should you need to make the app work with a different environment (e.g., you have your own instance of the Curity Identity Server already working online), then you should adjust settings,  by editing the `Configuration` module.

## Customizing the Look and Feel

The UI SDK allows for a simple change of the styles used by the view components. Have a look at the `XXX` files to see the techniques used in the demo app to change the default theme. Have a look at [the customization tutorial](https://curity.io/resources/learn/haapi-mobile-ios-customization) to learn more about changing the look and feel of your authentication flow.

## Resources

- [HAAPI UI SDK Guide](https://curity.io/resources/learn/haapi-mobile-ios-integration) that shows all the aspects of working with the Curity's HAAPI UI SDK.
- [A tutorial](https://curity.io/resources/learn/authentication-api-ios-sdk) that shows how to properly configure the Curity Identity Server and a client to use the Hypermedia API from an iOS app.
- [An article](https://curity.io/resources/learn/what-is-hypermedia-authentication-api/) that explains the Hypermedia Authentication API.

## More information

Please visit [curity.io](https://curity.io/) for more information about the Curity Identity Server.
