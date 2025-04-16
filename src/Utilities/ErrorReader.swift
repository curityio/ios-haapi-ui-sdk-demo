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

/*
 * If there is a configuration or infrastructure error, tha app must handle HAAPI errors
 * This code translates to the application's own error model
 * The code example uses a very simple error model to just display a string error
 */
struct ErrorReader {
    
    static func getBackendErrorDescription(error: HaapiError) -> String {
        
        var parts: [String] = []
        var code = ""
        var description = ""
        
        switch error
        {
        case .attestationFailure(let cause): description = cause!.localizedDescription
        case .serverError(let error, let errorDescription, _): code = error; description = errorDescription
        case .communication(let message, _): code = "http_error"; description = message
        default: description = error.failureReason
        }
        
        parts.append("code: \(code)")
        parts.append(description)
        return parts.joined(separator: ", ")
    }
    
    static func getFrontendErrorDescription(error: HaapiUIKitError) -> String {
        
        var code        = ""
        var description = ""
        switch error
        {
        case .illegalState(let reason): code = "illegal_state"; description = reason
        case .other(let error): code = "general_error"; description = error.localizedDescription
        default: code = error.error; description = error.failureReason
        }
        
        var parts: [String] = []
        parts.append("code: \(code)")
        parts.append(description)
        return parts.joined(separator: ", ")
    }
    
    static func getTokenErrorDescription(error: OAuthErrorModel) -> String {
        
        let code = error.error ?? "token_error"
        var description = error.errorDescription
        if description.isEmpty {
            description = "A token request failed"
        }

        var parts: [String] = []
        parts.append("code: \(code)")
        parts.append(description)
        return parts.joined(separator: ", ")
    }
}
