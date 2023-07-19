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
    
    @ObservedObject private var loginState: LoginState
    @State private var error: ApplicationError? = nil

    init(loginState: LoginState) {
        self.loginState = loginState
    }

    var body: some View {
        
        let deviceWidth = UIScreen.main.bounds.size.width
        let refreshEnabled = self.loginState.tokens?.refreshToken != nil
        let signOutEnabled = self.loginState.tokens?.idToken != nil

        return VStack {
            
            if self.error == nil {
                Text("authenticated_message")
                    .labelStyle()
                    .padding(.top, 20)
            } else {
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
        guard let accessToken = self.loginState.tokens?.accessToken else {
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

                    let givenName = userInfo["given_name"] as? String
                    let familyName = userInfo["family_name"] as? String
                    if (givenName != nil && familyName != nil) {
                        self.loginState.updateFromUserInfoResponse(userName: "\(givenName!) \(familyName!)")
                    }
                }
            }
            .resume()
        }
    }

    private func refreshAccessToken() {
        
        guard let refreshToken = self.loginState.tokens?.refreshToken else { return }

        fetchUserInfo()
        DispatchQueue.global().async {

            let errorTitle = "Token Refresh Error"
            let oauthTokenManager = OAuthTokenManagerAccessor().get()
            oauthTokenManager.refreshAccessToken(with: refreshToken) { response in
                
                switch response {
                    
                case .successfulToken(let successfulTokenResponse):
                    DispatchQueue.main.async {
                        self.loginState.updateFromTokenRefreshSuccessResponse(tokenResponse: successfulTokenResponse)
                    }
                    
                case .errorToken(let errorResponse):
                    DispatchQueue.main.async {
                        self.error = ApplicationError(title: errorTitle, description: errorResponse.errorDescription, code: errorResponse.error)
                    }
                    
                case .error(let error):
                    DispatchQueue.main.async {
                        self.error = ApplicationError(title: errorTitle, description: error.localizedDescription)
                    }
                }
            }
        }
    }
}
