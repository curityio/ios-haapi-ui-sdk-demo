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
        
        return VStack {
            
            HStack {
                Text("sub")
                Text(model.sub)
            }
            HStack {
                Text("given_name")
                Text(model.givenName)
            }
            HStack {
                Text("family_name")
                Text(model.familyName)
            }
            HStack {
                Text("preferred_username")
                Text(model.preferredUsernane)
            }
            HStack {
                Text("updated_at")
                Text(model.updatedAt)
            }
        }
    }
}
