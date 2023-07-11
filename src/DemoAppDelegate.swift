import SwiftUI
import IdsvrHaapiUIKit

class DemoAppDelegate: NSObject, UIApplicationDelegate {

    private enum Constants {
        static let clientId = "haapi-ios-client"
        static let redirectUri = "haapi:start"
        static let scopes = ["openid", "profile"]
        static let baseURL = URL(string: "https://login.example.com")!
        static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
        static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    }

    var haapiUIKitConfiguration = HaapiUIKitConfigurationBuilder(clientId: Constants.clientId,
                                                                 baseUrl: Constants.baseURL,
                                                                 tokenEndpointUrl: Constants.tokenEndpointURL,
                                                                 authorizationEndpointUrl: Constants.authorizationEndpointURL,
                                                                 appRedirect: Constants.redirectUri)
        .setOauthAuthorizationParamsProvider { OAuthAuthorizationParameters(scopes: Constants.scopes) }
        .build()

    var haapiUIKitApplication: HaapiUIKitApplication!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        HaapiLogger.followUpTags = DriverFollowUpTag.allCases + SdkFollowUpTag.allCases + UIKitFollowUpTag.allCases
        HaapiLogger.enabled = true
        
        haapiUIKitApplication = HaapiUIKitApplicationBuilder(haapiUIKitConfiguration: haapiUIKitConfiguration)
            .build()

        return true
    }
}

