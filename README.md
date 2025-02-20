# iOS Application using the HAAPI UI SDK

[![Quality](https://img.shields.io/badge/quality-test-yellow)](https://curity.io/resources/code-examples/status/)
[![Availability](https://img.shields.io/badge/availability-source-blue)](https://curity.io/resources/code-examples/status/)

This is an example iOS app that uses the Curity Identity Server's Hypermedia API to perform an OIDC flow.\
Authentication uses native screens without the need for an external browser.

## Getting Started

Start with a local automated deployment to ensure that you understand the technical setup.\
You can then apply the same configuration to deployed environments.

### 1. Deploy the the Curity Identity Server

Ensure that the local computer has these prerequisites:

- A Docker engine.
- The `envsubst` tool, e.g with `brew install gettext`.
- The `jq` tool, e.g with `brew install jq`.

First copy a `license.json` file for the Curity Identity Server into the root folder.\
Then run a Docker deployment and indicate how connected simulators or devices call the Curity Identity Server.\
The following example uses the ngrok tool to provide an internet HTTPS URL:

```bash
export USE_NGROK='true'
./start-idsvr.sh
```

Alternatively, provide a host name with which connected simulators or devices call the Curity Identity Server.\
The local computer's IP address should work or you can use `localhost` if you prefer.\
For example, run the following commands on a macOS computer:

```bash
export USE_NGROK='false'
export IDSVR_HOST_NAME="$(ipconfig getifaddr en0)"
./start-idsvr.sh
```

### 2. View Security Configuration

The [Mobile Deployments](https://github.com/curityio/mobile-deployments) repository explains further information about the deployed backend infrastructure.\
You can view the [HAAPI Configuration](https://github.com/curityio/mobile-deployments/blob/main/haapi/example-config-template.xml) to understand the settings to apply to deployed environments.

### 3. Test Basic Logins

Run the app and first test basic logins using an HTML Form authenticator.\
Sign in to the deployed environment and use a pre-shipped test user account.

- Username: `demouser`
- Password: `Password1`

### 4. Test Native Passkey Logins

Passkeys require hosting of assets documents at a trusted internet HTTPS URL.\
You must also provide overrides with your own Apple team ID and unique bundle identifier.\
You can use ngrok to host assets documents to enable the testing of passkeys logins.\
The following example commands deploy the Curity Identity Server with a passkeys configuration:

```bash
export APPLE_TEAM_ID='MYTEAMID'
export APPLE_BUNDLE_ID='io.myorganization.haapi.demo'
export USE_NGROK='true'
./start-idsvr.sh
```

In Xcode, configure the team ID and bundle ID under `Signing & Capabilities`.\
Also ensure that Apple development tools sign the app, such as with the `Automatically manage signing` option.

## Application Code

The following links point you to the most essential areas of the example app's source code.

### Main Source Files

This app only authenticates the user, then displays the tokens obtained from the authorization server.\
See the following source files to understand how that works:

- The [Configuration](src/Configuration.swift) object contains all of the OpenID Connect settings.
- The [DemoAppDelegate](src/DemoAppDelegate.swift) shows how to create a global object to complete the configuration.
- The [UnauthenticatedView](src/Views/UnauthenticatedView.swift) shows the code needed to manage logins using the HAAPI UI SDK.
- The [AuthenticatedView](src/Views/AuthenticatedView.swift) shows how to use tokens once the authentication workflow completes.

### Customizing the Look and Feel

The [HAAPI iOS customization tutorial](https://curity.io/resources/learn/haapi-mobile-ios-customization) explains how to change the default theme.\
See also the [Developer Documentation](https://curity.io/docs/haapi-ios-ui-kit/latest/) for the finer details of customization options.

## Resources

See the following tutorials for additional developer information:

- The [Swift iOS App using HAAPI](https://curity.io/resources/learn/swift-ios-haapi/) tutorial provides an overview of the code example's behaviors.
- The [ngrok tutorials](https://curity.io/resources/learn/mobile-setup-ngrok/) explain how to use an internet URL and [view HAAPI messages](https://curity.io/resources/learn/expose-local-curity-ngrok/#ngrok-inspection-and-status).
-  The [Configure Native Passkeys for Mobile Logins](https://curity.io/resources/learn/mobile-logins-using-native-passkeys/) tutorial explains the technical setup when using passkeys.
- The [HAAPI Mobile Guides](https://curity.io/resources/haapi-ui-sdk/) provide further details for HAAPI mobile developers.

## Further information

Please visit [curity.io](https://curity.io/) for more information about the Curity Identity Server.
