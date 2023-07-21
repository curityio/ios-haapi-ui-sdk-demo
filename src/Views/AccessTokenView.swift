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

import SwiftUI

struct AccessTokenView: View {
    
    @ObservedObject var model: AccessTokenModel
    
    init(model: AccessTokenModel) {
        self.model = model
    }

    var body: some View {
        
        let fontSize: CGFloat = 14
        let deviceWidth = UIScreen.main.bounds.size.width
        let paddingWidth = deviceWidth / 12
        let frameWidth = deviceWidth / 3

        return VStack {
            
            HStack {
                Text("token_type:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
                
                Text(model.tokenType)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
            
            HStack {
                Text("scope:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
                
                Text(model.scope)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
            
            HStack {
                Text("expires_in:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
        
                Text(model.expiresIn)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
        }
    }
}
