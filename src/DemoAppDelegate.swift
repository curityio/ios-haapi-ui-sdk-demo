//
// Copyright (C) 2023 Curity AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI
import IdsvrHaapiUIKit

class DemoAppDelegate: NSObject, UIApplicationDelegate {

    private enum Constants {
        static let clientId = "haapi-ios-dev-client"
        static let redirectUri = "haapi:start"
        static let scopes = ["openid", "profile"]
        static let baseURL = URL(string: "http://localhost:8443")!
        static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
        static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    }

    var haapiUIKitApplication: HaapiUIKitApplication!
    var loginState: LoginState!
    var oauthTokenManager: OAuthTokenManager!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        HaapiLogger.followUpTags = DriverFollowUpTag.allCases + SdkFollowUpTag.allCases + UIKitFollowUpTag.allCases
        HaapiLogger.enabled = false

        let haapiUIKitConfiguration = HaapiUIKitConfigurationBuilder(clientId: Constants.clientId,
                                                                     baseUrl: Constants.baseURL,
                                                                     tokenEndpointUrl: Constants.tokenEndpointURL,
                                                                     authorizationEndpointUrl: Constants.authorizationEndpointURL,
                                                                     appRedirect: Constants.redirectUri)
            .setOauthAuthorizationParamsProvider { OAuthAuthorizationParameters(
                scopes: Constants.scopes
            ) }
            .setURLSession(session: URLSession(configuration: .haapi,
                                               delegate: TrustAllCertsDelegate(),
                                               delegateQueue: nil))
            .setPresentationMode(mode: PresentationMode.modal)
            .setShouldAutoHandleFlowErrorFeedback(value: false)
            .build()
        
        self.haapiUIKitApplication = HaapiUIKitApplicationBuilder(haapiUIKitConfiguration: haapiUIKitConfiguration)
            .build()
        
        self.oauthTokenManager = OAuthTokenManagerAccessor(clientId: Constants.clientId, tokenEndpointURL: Constants.tokenEndpointURL).get()
        self.loginState = LoginState()
        return true
    }
}
