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

struct AuthenticatedView: View, HaapiFlowResult {
    
    private let haapiApplication: HaapiUIKitApplication

    @ObservedObject private var oauthState: OAuthStateModel
    @State private var error: ApplicationError? = nil

    init(haapiApplication: HaapiUIKitApplication, oauthState: OAuthStateModel) {
        self.haapiApplication = haapiApplication
        self.oauthState = oauthState
    }

    var body: some View {
        
        let refreshEnabled = self.oauthState.refreshToken != nil
        let signOutEnabled = self.oauthState.idToken != nil
        
        return ScrollView {
            VStack {
                
                Image("example_logo")
                    .padding(.top, 20)
                
                if self.error == nil {
                    Text("authenticated_message")
                        .subHeadingStyle(size: 24)
                        .padding(.top, 20)
                } else {
                    ErrorView(error: self.error!)
                        .padding(.top, 20)
                }
                
                VStack {
                      
                    ExpanderView(label: Text("User Info").labelStyle()) {
                        if self.oauthState.userInfo != nil {
                            UserInfoView(model: self.oauthState.userInfo!)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.top, 5)
                    
                    ExpanderView(label: Text("Access token").labelStyle(), expanded: true) {
                        VStack {
                            Text(self.oauthState.accessToken ?? "").valueStyle()
                            if self.oauthState.accessToken != nil {
                                AccessTokenView(model: self.oauthState.accessTokenModel!)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding(.top, 5)
                    
                    ExpanderView(label: Text("ID token").labelStyle()) {
                        Text(self.oauthState.idToken ?? "").valueStyle()
                    }
                    .padding(.top, 5)
                    
                    ExpanderView(label: Text("Refresh token").labelStyle()) {
                        Text(self.oauthState.refreshToken ?? "").valueStyle()
                    }
                    .padding(.top, 5)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
                Button(action: self.refreshAccessToken) {
                    Text("refresh_access_token")
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .buttonStyle(CustomButtonStyle(disabled: !refreshEnabled))
                .disabled(!refreshEnabled)
                
                Button(action: self.logout) {
                    Text("sign_out")
                }
                .padding(.top, 5)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .buttonStyle(CustomButtonStyle(disabled: !signOutEnabled))
                .disabled(!signOutEnabled)
                
                Spacer()
            }
            .onAppear(perform: self.fetchUserInfo)
        }
    }
    
    private func fetchUserInfo() {
        
        guard let accessToken = self.oauthState.accessToken else {
            return
        }
        
        DispatchQueue.global().async {
            
            let errorTitle = "User Info Error"
            var urlRequest = URLRequest(url: Configuration.userInfoEndpointURL)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let urlSession = URLSession(configuration: .haapi,
                                        delegate: TrustAllCertsDelegate(),
                                        delegateQueue: nil)
            urlSession.dataTask(with: urlRequest) { data, response, error in

                DispatchQueue.main.async {

                    if error != nil {
                        self.error = ApplicationError(title: errorTitle, description: error?.localizedDescription ?? "")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.error = ApplicationError(title: errorTitle, description: "Unexpected HTTP response")
                        return
                    }

                    if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                        self.error = ApplicationError(title: "User Info Error", description: "HTTP response status code: \(httpResponse.statusCode)")
                        return
                    }

                    guard let userInfo = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
                        self.error = ApplicationError(title: "User Info Error", description: "Unable to deserialize user info")
                        return
                    }
                    
                    self.oauthState.updateFromUserInfoResponse(userInfo: userInfo)
                }
            }
            .resume()
        }
    }
    
    func refreshAccessToken() {
        
        guard let refreshToken = self.oauthState.refreshToken else {
            return
        }
        
        OAuthLifecycle.refreshToken(
            refreshToken: refreshToken,
            haapiUIKitApplication: self.haapiApplication,
            lifecycleResultListener: self
        )
    }
    
    func logout() {
        self.oauthState.removeAllTokens()
    }

    func didReceiveOAuthModel(_ tokens: OAuthModel) {

        guard let model = tokens as? OAuthTokenModel else {
            self.error = ApplicationError(title: "HAAPI Token Refresh Error", description: "No tokens returned in token refresh response")
            return
        }
        
        self.oauthState.updateFromTokenRefreshSuccessResponse(tokens: model)
        self.error = nil
    }

    func didReceiveError(_ error: Error) {
        self.error = ApplicationError(title: "HAAPI Token Refresh Error", description: error.localizedDescription)
    }
}
