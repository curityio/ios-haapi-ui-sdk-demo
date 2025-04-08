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

class AuthenticationSelectorButton: UIButton {
    
    private var model: SelectorItemInteractionActionModel
    
    init(model: SelectorItemInteractionActionModel) {
        self.model = model
        super.init(frame: .zero)
        
        self.setTitle(getText(), for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "Primary")
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getModel() -> SelectorItemInteractionActionModel {
        return model
    }

    private func getText() -> String {
        
        if model.type == "passkeys" {
            return "Sign in with a passkey"
        }
        
        if model.type == "html-form" {
            return "Sign in with a password"
        }
        
        return "Sign in with \(getType())"
    }
    
    public func getType() -> String {
        return model.type ?? ""
    }
}
