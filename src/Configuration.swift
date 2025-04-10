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

import Foundation

struct Configuration {
    static let clientId = "haapi-ios-client"
    static let redirectUri = "haapi://callback"
    static let scopes = ["openid", "profile"]
    static let baseURL = URL(string: "https://localhost:8443")!
    static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
    static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    static let userInfoEndpointURL = URL(string: "/oauth/v2/oauth-userinfo", relativeTo: baseURL)!
    
    static let dcrTemplateClientId: String? = nil
    static let dcrClientRegistrationEndpointPath: String? = nil
    static let deviceSecret: String? = nil
    
    // Uncomment these fields to add support for HAAPI DCR fallback with a simple credential
    //static let dcrTemplateClientId: String? = "haapi-template-client"
    //static let dcrClientRegistrationEndpointPath: String? = "/token-service/oauth-registration"
    //static let deviceSecret: String? = "Password1"
}
