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

@main
struct DemoApp: App {
    
    @UIApplicationDelegateAdaptor(DemoAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView(
                haapiApplication: appDelegate.haapiUIKitApplication,
                loginState: appDelegate.loginState)
                    .onOpenURL(perform: handleUrl(url:))
        }
    }
    
    func handleUrl(url: URL) {
        if HaapiDeepLinkManager.shared.canHandleUrl(url) {
            HaapiDeepLinkManager.shared.handleUrl(url)
        }
    }
}
