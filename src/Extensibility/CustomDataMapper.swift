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
 * The entry point for customizing UI models
 */
class CustomDataMapper: DataMapper {

    let defaultMapper: DataMapper
    
    init() {
        defaultMapper = DataMapperBuilder(
            redirectTo: Configuration.redirectUri,
            autoPollingDuration: 3,
            authSelectionPresentation: AuthenticatorSelectionPresentation.list)
                .build()
    }

    func mapHaapiResultToUIModel(haapiResult: HaapiResult) throws -> any UIModel {
        
        let defaultModel = try defaultMapper.mapHaapiResultToUIModel(haapiResult: haapiResult)
        
        // If this is the HTML login form then customize the model that HAAPI renders
        if let formModel = defaultModel as? FormModel {
            if formModel.viewName == "authenticator/html-form/authenticate/get" {
                return HtmlFormLoginModel.create(formModel: formModel)
            }
        }
        
        return defaultModel
    }
    
    func mapHaapiRepresentationToInteraction(haapiRepresentation: any HaapiRepresentation) throws -> any UIInteractionModel {
        return try defaultMapper.mapHaapiRepresentationToInteraction(haapiRepresentation: haapiRepresentation)
    }

    func mapRepresentationActionModelToUIInteractionModel(representationActionModel: any RepresentationActionModel) throws -> any UIInteractionModel {
        return try defaultMapper.mapRepresentationActionModelToUIInteractionModel(representationActionModel: representationActionModel)
    }
}
