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

struct UnauthenticatedView: View, HaapiFlowResult {
    
    private let haapiApplication: HaapiUIKitApplication

    @ObservedObject private var loginState: LoginState
    @State private var error: ApplicationError? = nil
    
    init(haapiApplication: HaapiUIKitApplication, loginState: LoginState) {
        self.haapiApplication = haapiApplication
        self.loginState = loginState
    }
    
    var body: some View {
        
        VStack {
            
            if self.error == nil {
                Text("welcome_message")
                    .labelStyle()
                    .padding(.top, 20)
            } else {
                ErrorView(error: self.error!)
                    .padding(.top, 20)
            }
                        
            Image("StartIllustration")
                .aspectRatio(contentMode: .fit)
                .padding(.top, 20)
            
            Button {
                self.loginState.isLoggingIn = true
            } label: {
                Text("start_authentication")
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .buttonStyle(CustomButtonStyle())
            
            Spacer()
        }
        .sheet(isPresented: $loginState.isLoggingIn) {
            
            HaapiFlow.start(
                self,
                haapiUIKitApplication: self.haapiApplication,
                haapiDeepLinkManageable: HaapiDeepLinkManager.shared)
        }
    }

    func didReceiveOAuthTokenModel(_ tokens: IdsvrHaapiUIKit.OAuthTokenModel) {
        self.loginState.isLoggingIn = false
        self.loginState.updateFromLoginResponse(tokens: tokens)
        self.error = nil
    }

    func didReceiveError(_ error: Error) {
        self.loginState.isLoggingIn = false
        self.loginState.clear()
        self.error = ApplicationError(title: "HAAPI Login Error", description: error.localizedDescription)
    }
}
