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

struct AuthenticatedView: View {
    
    private let haapiApplication: HaapiUIKitApplication
    private let oauthTokenManager: OAuthTokenManager

    @ObservedObject private var loginState: LoginState
    @State private var error: Error? = nil

    init(haapiApplication: HaapiUIKitApplication, loginState: LoginState, oauthTokenManager: OAuthTokenManager) {
        self.haapiApplication = haapiApplication
        self.loginState = loginState
        self.oauthTokenManager = oauthTokenManager
    }

    var body: some View {
        
        let deviceWidth = UIScreen.main.bounds.size.width
        let refreshEnabled = self.loginState.tokens?.refreshToken != nil
        let signOutEnabled = self.loginState.tokens?.idToken != nil

        return VStack {
            
            if self.error != nil {
                ErrorView(error: self.error!)
                    .padding(.top, 20)
            }
           
            Text("username")
                .labelStyle()
                .padding(.top, 20)
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)
                
            Text(self.loginState.userName ?? "")
                .valueStyle()
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)
            
            Text("access_token")
                .labelStyle()
                .padding(.top, 20)
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)
            
            Text(self.loginState.tokens?.accessToken ?? "")
                .valueStyle()
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)

            Text("refresh_token")
                .labelStyle()
                .padding(.top, 20)
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)

            Text(self.loginState.tokens?.refreshToken ?? "")
                .valueStyle()
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)
            
            Button(action: self.refreshAccessToken) {
               Text("refresh_access_token")
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .buttonStyle(CustomButtonStyle(disabled: !refreshEnabled))
            .disabled(!refreshEnabled)
            
            Button(action: self.loginState.clear) {
               Text("sign_out")
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .buttonStyle(CustomButtonStyle(disabled: !signOutEnabled))
                        .disabled(!signOutEnabled)

            Spacer()
        }
        .onAppear(perform: self.fetchUserInfo)
    }
    
    private func fetchUserInfo() {
        
        if (self.loginState.userName != nil) {
            return
        }
        
        /*
        
        let accessToken = self.loginState.tokens?.accessToken
        
        var urlRequest = URLRequest(url: userinfoEndpointURL.unsafelyUnwrapped,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 20)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlSession.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                guard error == nil, let data = data else {
                    self.userInfo = nil
                    return
                }

                guard let userInfo = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    self.userInfo = nil
                    return
                }

                self.userInfo = "\(userInfo["given_name"]) \(userInfo["family_name"])"
            }
        }
        .resume()*/
    }
    
    private func refreshAccessToken() {
        
        guard let refreshToken = self.loginState.tokens?.refreshToken else { return }
        self.oauthTokenManager.refreshAccessToken(with: refreshToken) { response in
    
            if case let .successfulToken(tokenResponse) = response {
                DispatchQueue.main.async {
                    self.loginState.updateFromTokenRefreshSuccessResponse(tokenResponse: tokenResponse)
                }
            }
            
            if case let .errorToken(errorResponse) = response {
                DispatchQueue.main.async {
                    let description = "Token refresh error: \(errorResponse.error), \(errorResponse.errorDescription)"
                    self.error = ApplicationError(description: description)
                }
            }
        }
    }
}
