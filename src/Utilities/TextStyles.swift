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

extension Text {
    
    private enum Constants {
        static let regularFont = "IBMPlexMono-Regular"
        static let mediumFont = "IBMPlexMono-Medium"
        static let boldFont = "IBMPlexMono-Bold"
    }
    
    func titleStyle() -> Text {

        return foregroundColor(Color.black)
                .font(.custom(Constants.regularFont, size: 40))
    }
    
    func headingStyle() -> Text {

        return foregroundColor(Color.black)
                .font(.custom(Constants.boldFont, size: 20))
    }
    
    func labelStyle() -> Text {

       return foregroundColor(Color("LightBlack"))
                .font(.custom(Constants.mediumFont, size: 16))
    }

    func valueStyle() -> Text {

        return foregroundColor(Color.blue)
                .font(.custom(Constants.mediumFont, size: 16))
    }

    func errorValueStyle() -> Text {

        return foregroundColor(Color.red)
                .font(.custom(Constants.mediumFont, size: 16))
    }
}


