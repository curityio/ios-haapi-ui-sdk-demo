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

struct UserInfoView: View {
    
    @ObservedObject var model: UserInfoModel
    
    init(model: UserInfoModel) {
        self.model = model
    }

    var body: some View {

        let fontSize: CGFloat = 14
        let deviceWidth = UIScreen.main.bounds.size.width
        let paddingWidth = deviceWidth / 12
        let frameWidth = deviceWidth / 3
        
        return VStack {
            
            HStack {
                Text("sub:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
   
                Text(model.sub)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
            
            HStack {
                Text("given_name:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)

                Text(model.givenName)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
            HStack {
                Text("family_name:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)

                Text(model.familyName)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
            HStack {
                Text("preferred_username:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)

                Text(model.preferredUsernane)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
            HStack {
                Text("updated_at:")
                    .labelStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)

                Text(model.updatedAt)
                    .valueStyle(size: fontSize)
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading, paddingWidth)
            }
        }
    }
}
