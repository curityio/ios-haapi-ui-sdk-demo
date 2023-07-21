import SwiftUI

struct AuthenticatedView: View {
    
    @ObservedObject private var oauthState: OAuthStateModel
    @State private var error: ApplicationError? = nil

    init(oauthState: OAuthStateModel) {
        self.oauthState = oauthState
    }

    var body: some View {
        
        let refreshEnabled = self.oauthState.tokens?.refreshToken != nil
        let signOutEnabled = self.oauthState.tokens?.idToken != nil
        
        return ScrollView {
            VStack {
                
                if self.error == nil {
                    Text("authenticated_message")
                        .headingStyle()
                        .padding(.top, 20)
                } else {
                    ErrorView(error: self.error!)
                        .padding(.top, 20)
                }
                
                VStack {
                    ExpanderView(label: Text("User Info").subHeadingStyle()) {
                        if self.oauthState.userInfo != nil {
                            UserInfoView(model: self.oauthState.userInfo!)
                        }
                    }
                    .padding(.top, 20)
                    
                    ExpanderView(label: Text("Access token").subHeadingStyle(), expanded: true) {
                        VStack {
                            Text(self.oauthState.tokens?.accessToken ?? "").valueStyle()
                            if self.oauthState.tokens != nil {
                                AccessTokenView(model: AccessTokenModel(tokens: self.oauthState.tokens!))
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    ExpanderView(label: Text("ID token").subHeadingStyle()) {
                        Text(self.oauthState.tokens?.idToken ?? "").valueStyle()
                    }
                    .padding(.top, 20)
                    
                    ExpanderView(label: Text("Refresh token").subHeadingStyle()) {
                        Text(self.oauthState.tokens?.refreshToken ?? "").valueStyle()
                    }
                    .padding(.top, 20)
                }
                .padding(.leading, 50)
                .padding(.trailing, 50)
                
                Button(action: self.refreshAccessToken) {
                    Text("refresh_access_token")
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .buttonStyle(CustomButtonStyle(disabled: !refreshEnabled))
                .disabled(!refreshEnabled)
                
                Button(action: self.oauthState.clear) {
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
        
        guard let accessToken = self.oauthState.tokens?.accessToken else {
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

    private func refreshAccessToken() {
        
        guard let refreshToken = self.oauthState.tokens?.refreshToken else { return }

        DispatchQueue.global().async {

            let errorTitle = "Token Refresh Error"
            let oauthTokenManager = OAuthTokenManagerAccessor().get()
            oauthTokenManager.refreshAccessToken(with: refreshToken) { response in
                
                switch response {
                    
                case .successfulToken(let successfulTokenResponse):
                    DispatchQueue.main.async {
                        self.oauthState.updateFromTokenRefreshSuccessResponse(tokenResponse: successfulTokenResponse)
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
