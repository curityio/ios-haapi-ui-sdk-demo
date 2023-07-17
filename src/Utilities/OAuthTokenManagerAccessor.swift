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

import IdsvrHaapiUIKit

public class OAuthTokenManagerAccessor: OAuthTokenConfigurable {
    
    public let clientId: String
    public let tokenEndpointURL: URL
    public let appRedirect: String
    public let urlSession: URLSession
    public let revocationEndpointURL: URL?

    public init(clientId: String, tokenEndpointURL: URL) {
        
        self.clientId = clientId
        self.tokenEndpointURL = tokenEndpointURL
        self.appRedirect = ""
        self.urlSession = URLSession(configuration: .haapi,
                                     delegate: TrustAllCertsDelegate(),
                                     delegateQueue: nil)
        self.revocationEndpointURL  = nil
    }
    
    public func get() -> OAuthTokenManager {
        return OAuthTokenManager(oauthTokenConfiguration: self)
    }
}
