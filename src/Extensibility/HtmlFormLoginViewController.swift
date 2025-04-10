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

import UIKit
import IdsvrHaapiUIKit

/*
 * Customize the view controller for the HTML form's login screen
 */
class HtmlFormLoginFormViewController: FormViewController {
    
    init(model: FormModel, style: FormViewControllerStyle, commonStyle: HaapiUIViewControllerStyle) {
        super.init(model, style: style, commonStyle: commonStyle)
    }

    /*
     * Implement custom logic when the view loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if let customModel = model as? HtmlFormLoginModel {
            
            // Operate on custom model data if required
            let label = UILabel(frame: .zero)
            label.text = customModel.userMessage
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(named: "Primary")
            label.textAlignment = .center
            label.accessibilityIdentifier = "user_message"

            insertView(label, aboveView: messagesStackView)
        }
    }
    
    /*
     * Do any custom validation before submitting the login data to the Curity Identity Server
     */
    override func preSubmit(
        interactionActionModel: InteractionActionModel,
        parameters: [String: Any],
        closure: @escaping (Bool, [String: Any]) -> Void) {
        
        closure(true, parameters)
    }
}
