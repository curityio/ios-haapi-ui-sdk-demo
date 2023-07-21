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

class OAuthStateModel: ObservableObject {
    
    @Published var isLoggingIn: Bool = false
    @Published var tokens: OAuthTokenModel? = nil
    @Published var accessTokenModel: AccessTokenModel? = nil
    @Published var userInfo: UserInfoModel? = nil

    func updateFromLoginResponse(tokens: OAuthTokenModel) {
        self.tokens = tokens
        self.accessTokenModel = AccessTokenModel(tokens: tokens)
    }

    func updateFromUserInfoResponse(userInfo: Dictionary<String, Any>) {
        self.userInfo = UserInfoModel(data: userInfo)
    }

    func updateFromTokenRefreshSuccessResponse(tokenResponse: SuccessfulTokenResponse) {
        
        self.tokens = OAuthTokens(
            accessToken: tokenResponse.accessToken,
            tokenType: tokenResponse.tokenType,
            scope: tokenResponse.scope,
            expiresIn: tokenResponse.expiresIn,
            refreshToken: tokenResponse.refreshToken,
            idToken: tokenResponse.idToken ?? self.tokens?.idToken)
        
        self.accessTokenModel = AccessTokenModel(tokens: self.tokens)
    }

    func clear() {
        self.tokens = nil
        self.userInfo = nil
    }
}
