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

class AuthenticationSelectionViewController: UIViewController, HaapiUIViewController {
    
    var haapiFlowViewControllerDelegate: HaapiFlowViewControllerDelegate?
    var uiStylableThemeDelegate: UIStylableThemeDelegate?
    
    var model: SelectorModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: SelectorModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    func onAction() {
        /*haapiFlowViewControllerDelegate?.submit(
            interactionActionModel: model.interactionItems.first as! InteractionActionModel,
            parameters: [:]
        )*/
    }
    
    func stopLoading() {
        // Custom code here
    }
    
    func hasLoading() -> Bool {
        // Custom code here
        return false
    }
    
    func handleProblemModel(_ problemModel: ProblemModel) -> Bool {
        // Custom code here
        return false
    }
    
    func handleInfoMessageModels(_ infoMessageModels: [InfoMessageModel]) {
        // Custom code here
    }
    
    func handleLinkItemModels(_ linkItemModels: [any LinkItemModel]) {
        // Custom code here
    }
    
    func handleFormModel(_ formModel: FormModel) -> Bool {
        // Custom code here
        return false
    }
    
    func hideHeaderView() {
        // Custom code here
    }
    
    func preSubmit(interactionActionModel: any IdsvrHaapiUIKit.InteractionActionModel, parameters: [String: Any], closure: (Bool, [String: Any]) -> Void) {
        closure(true, parameters)
    }
        
    func preSelect(selectorItemModel: any IdsvrHaapiUIKit.SelectorItemInteractionActionModel, closure: (Bool) -> Void) {
        closure(true)
    }
        
    func preFollow(linkItemModel: any IdsvrHaapiUIKit.LinkItemModel, closure: (Bool) -> Void) {
        closure(true)
    }
}
