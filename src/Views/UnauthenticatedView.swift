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

    @ObservedObject private var oauthState: OAuthStateModel
    @State private var error: ApplicationError? = nil
    
    init(haapiApplication: HaapiUIKitApplication, oauthState: OAuthStateModel) {
        self.haapiApplication = haapiApplication
        self.oauthState = oauthState
    }
    
    var body: some View {
        
        VStack {
            
            Text("unauthenticated_title")
                    .titleStyle()
                    .padding(.top, 20)
                    .padding(.leading, 20)
            
            if self.error == nil {
                Text("welcome_message")
                    .labelStyle()
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            } else {
                ErrorView(error: self.error!)
            }
            
            Image("StartIllustration")
                .aspectRatio(contentMode: .fit)
                .padding(.top, 60)

            Button {
                self.oauthState.isLoggingIn = true
            } label: {
                Text("start_authentication")
            }
                .padding(.top, 80)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .buttonStyle(CustomButtonStyle())
            
            Spacer()
        }
        .sheet(isPresented: $oauthState.isLoggingIn) {
            
            HaapiFlow.start(
                self,
                haapiUIKitApplication: self.haapiApplication,
                haapiDeepLinkManageable: HaapiDeepLinkManager.shared)
        }
    }
    
    func didReceiveOAuthModel(_ tokens: OAuthModel) {

        self.oauthState.isLoggingIn = false

        if let error = tokens as? OAuthErrorModel {
            self.error = ApplicationError(
                title: "HAAPI Token Error",
                description: ErrorReader.getTokenErrorDescription(error: error))
            return
        }

        guard let model = tokens as? OAuthTokenModel else {
            self.error = ApplicationError(
                title: "HAAPI Token Error",
                description: "No tokens returned in token response")
            return
        }
        
        self.oauthState.updateFromLoginResponse(tokens: model)
        self.error = nil
    }

    func didReceiveError(_ error: Error) {
        
        self.oauthState.isLoggingIn = false
        if let backendError = error as? HaapiError {
            
            self.error = ApplicationError(
                title: "HAAPI Server Error",
                description: ErrorReader.getBackendErrorDescription(error: backendError))
    
        } else if let frontendError = error as? HaapiUIKitError {
            
            self.error = ApplicationError(
                title: "HAAPI Client Error",
                description: ErrorReader.getFrontendErrorDescription(error: frontendError))
    
        } else {
    
            self.error = ApplicationError(
                title: "HAAPI Error",
                description: error.localizedDescription)
        }
    }
}
