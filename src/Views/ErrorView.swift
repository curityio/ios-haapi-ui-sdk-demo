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

struct ErrorView: View {

    private let error: ApplicationError
    
    init(error: ApplicationError) {
        self.error = error
    }
    
    var body: some View {
        
        let deviceWidth = UIScreen.main.bounds.size.width
    
        return VStack {
            
            Text(self.error.title)
                .headingStyle()
                .padding(.top, 10)
                .padding(.leading, 20)
                .frame(width: deviceWidth, alignment: .leading)
            
            Text(self.error.getDetails())
                .errorValueStyle()
                .padding(.leading, 20)
                .frame(width: deviceWidth, height: 80, alignment: .top)
        }
    }
}

