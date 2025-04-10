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

/*
 * Create custom view controllers for particular login screens
 */
class CustomViewControllerFactory {
    
    /*
     * Override particular form screens
     */
    public func createFormViewController(model: FormModel, style: FormViewControllerStyle, commonStyle: HaapiUIViewControllerStyle) throws -> any HaapiUIViewController {

        // Partially customize the HTML form login screen
        if model is HtmlFormLoginModel {
            return HtmlFormLoginFormViewController(model: model, style: style, commonStyle: commonStyle)
        }

        return FormViewController(model, style: style, commonStyle: commonStyle)
    }
    
    /*
     * Override particular selector screens
     */
    public func createSelectorViewController(model: SelectorModel, style: SelectorViewControllerStyle, commonStyle: HaapiUIViewControllerStyle) throws -> any HaapiUIViewController {
        
        // Completely replace the authentication selector screen
        if model.viewName == "views/select-authenticator/index" {
            return AuthenticationSelectionViewController(model: model)
        }
        
        return SelectorViewController(model, style: style, commonStyle: commonStyle)
    }
}
