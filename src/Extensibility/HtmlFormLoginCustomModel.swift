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
 * Customize the data for the HTML form's login screen
 */
struct HtmlFormLoginCustomModel: FormModel {
    var headerDescription: String
    var interactionItems: [InteractionItemModel]
    var linkItems: [LinkItemModel]
    var messageItems: [InfoMessageModel]
    var templateArea: String?
    var viewName: String?
    
    /*
     * Remove Forgot Username and add a custom header description
     */
    static func fromDefaultModel(formModel: FormModel) -> HtmlFormLoginCustomModel {
        
        return HtmlFormLoginCustomModel(
            headerDescription: "This is a header description",
            interactionItems: formModel.interactionItems,
            linkItems: formModel.linkItems.filter({$0.rel != "forgot-account-id"}),
            messageItems: formModel.messageItems,
            templateArea: formModel.templateArea,
            viewName: formModel.viewName)
    }
}
