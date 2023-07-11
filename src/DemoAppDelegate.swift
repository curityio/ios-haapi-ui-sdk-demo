import SwiftUI
import IdsvrHaapiUIKit

class DemoAppDelegate: NSObject, UIApplicationDelegate {

    private enum Constants {
        static let clientId = "haapi-ios-dev-client"
        static let redirectUri = "haapi:start"
        static let scopes = ["openid", "profile"]
        static let baseURL = URL(string: "https://localhost:8443")!
        static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
        static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    }

    var haapiUIKitConfiguration = HaapiUIKitConfigurationBuilder(clientId: Constants.clientId,
                                                                 baseUrl: Constants.baseURL,
                                                                 tokenEndpointUrl: Constants.tokenEndpointURL,
                                                                 authorizationEndpointUrl: Constants.authorizationEndpointURL,
                                                                 appRedirect: Constants.redirectUri)
        .setOauthAuthorizationParamsProvider { OAuthAuthorizationParameters(scopes: Constants.scopes) }
        .setURLSession(session: URLSession(configuration: .haapi,
                                           delegate: TrustAllCertsDelegate(),
                                           delegateQueue: nil))
        .setPresentationMode(mode: PresentationMode.modal)
        .setShouldAutoHandleFlowErrorFeedback(value: false)
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
