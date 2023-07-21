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

    @ObservedObject private var loginState: LoginState

    init(haapiApplication: HaapiUIKitApplication, loginState: LoginState) {
        self.haapiApplication = haapiApplication
        self.loginState = loginState
    }

    var body: some View {

        return VStack {
            
            Text("main_title")
                    .titleStyle()
                    .padding(.top, 20)
                    .padding(.leading, 20)

            if (self.loginState.tokens == nil) {
                UnauthenticatedView(haapiApplication: self.haapiApplication, loginState: self.loginState)
                
            } else {
                AuthenticatedView(loginState: self.loginState)
            }
        }
        .background(Color("ViewBackground"))
    }
}
