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

    var haapiUIKitApplication: HaapiUIKitApplication!
    var oauthState: OAuthStateModel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Uncomment to activate logs
        // HaapiLogger.isInfoEnabled = true
        // HaapiLogger.isDebugEnabled = true
        // HaapiLogger.isSensitiveValueMasked = false
        // HaapiLogger.followUpTags = DriverFollowUpTag.allCases + SdkFollowUpTag.allCases + UIKitFollowUpTag.allCases
        
        // The base configuration
        let builder = HaapiUIKitConfigurationBuilder(clientId: Configuration.clientId,
                                                     baseUrl: Configuration.baseURL,
                                                     tokenEndpointUrl: Configuration.tokenEndpointURL,
                                                     authorizationEndpointUrl: Configuration.authorizationEndpointURL,
                                                     appRedirect: Configuration.redirectUri)
            .setOauthAuthorizationParamsProvider { OAuthAuthorizationParameters(
                scopes: Configuration.scopes
            ) }
            .setTokenBoundConfiguration(configuration: BoundedTokenConfiguration())
            .setURLSession(session: URLSession(configuration: .haapi,
                                               delegate: TrustAllCertsDelegate(),
                                               delegateQueue: nil))
            .setPresentationMode(mode: PresentationMode.modal)
            .setShouldAutoHandleFlowErrorFeedback(value: false)
        
        // If you run into particular iOS devices that do not support attestation you can activate DCR fallback
        if Configuration.dcrTemplateClientId != nil {
            
            builder.setClientAuthenticationMethod(method: ClientAuthenticationMethodSecret(secret: Configuration.deviceSecret!))
            builder.setDCRConfiguration(configuration: DCRConfiguration(
                templateClientId: Configuration.dcrTemplateClientId!,
                clientRegistrationEndpointUrl: URL(string: Configuration.dcrClientRegistrationEndpointPath!,
                                                   relativeTo: Configuration.baseURL)!))
        }
        
        let haapiUIKitConfiguration = builder.build()
        
        // Create extensibility objects to override model data or view logic
        let dataMapper = CustomDataMapper()
        let customViewControllerResolver = CustomViewControllerResolver()
        let registry = ViewControllerFactoryRegistry()
            .registerViewControllerFactoryFormModel(factory: customViewControllerResolver.createFormViewController)
            .registerViewControllerFactorySelectorModel(factory: customViewControllerResolver.createSelectorViewController)

        // Create the application
        try! self.haapiUIKitApplication = HaapiUIKitApplicationBuilder(
            haapiUIKitConfiguration: haapiUIKitConfiguration)
                .setThemingPlistFileName("CustomTheme")
                .setDataMapper(dataMapper)
                .setViewControllerFactoryRegistry(registry: registry)
                .buildOrThrow()

        self.oauthState = OAuthStateModel()
        return true
    }
}
