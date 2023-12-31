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

struct MainView: View {
    
    private let haapiApplication: HaapiUIKitApplication

    @ObservedObject private var oauthState: OAuthStateModel

    init(haapiApplication: HaapiUIKitApplication, oauthState: OAuthStateModel) {
        self.haapiApplication = haapiApplication
        self.oauthState = oauthState
    }

    var body: some View {

        return VStack(spacing: 0) {
            
            Text("banner_title")
                .font(.system(size: 24))
                .frame(width: UIScreen.main.bounds.size.width * 1.0, height: 50, alignment: .leading)
                .padding(.leading, 20)
                .background(Color.black)
                .foregroundColor(Color.white)
            
            VStack {
                if self.oauthState.accessToken == nil {
                    UnauthenticatedView(haapiApplication: self.haapiApplication, oauthState: self.oauthState)
                    
                } else {
                    AuthenticatedView(haapiApplication: self.haapiApplication, oauthState: self.oauthState)
                }
            }
            .background(Color("ViewBackground"))
        }
       
    }
}
