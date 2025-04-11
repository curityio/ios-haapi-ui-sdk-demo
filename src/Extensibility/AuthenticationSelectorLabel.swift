//
// Copyright (C) 2025 Curity AB.
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
import UIKit

class AuthenticationSelectorLabel: UILabel {
    
    private var authenticatorType: String
    
    init(authenticatorType: String) {
        self.authenticatorType = authenticatorType
        super.init(frame: .zero)
        
        self.text = getText(type: authenticatorType)
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor(named: "GeneralText")
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getText(type: String) -> String {
        
        if type == "passkeys" {
            return "Passkeys provide modern usability and strong security to protect your account"
        }
        
        if type == "html-form" {
            return "You can also sign in with a traditional username and password"
        }
        
        return ""
    }
}
