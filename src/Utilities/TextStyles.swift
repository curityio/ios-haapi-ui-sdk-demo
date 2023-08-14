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
    
    func titleStyle() -> Text {

        return foregroundColor(Color("GeneralText"))
            .font(.system(size: 40))
    }

    func headingStyle(size: CGFloat = 20) -> Text {

        return foregroundColor(Color("GeneralText"))
                .font(.system(size: size))
    }
    
    func subHeadingStyle(size: CGFloat = 20) -> Text {

        return foregroundColor(Color("GeneralText"))
                .font(.system(size: size))
    }
    
    func labelStyle(size: CGFloat = 16) -> Text {

       return foregroundColor(Color("GeneralText"))
                .font(.system(size: size))
    }

    func valueStyle(size: CGFloat = 16) -> Text {

        return foregroundColor(Color.blue)
                .font(.system(size: size))
    }

    func errorValueStyle(size: CGFloat = 16) -> Text {

        return foregroundColor(Color.red)
                .font(.system(size: size))
    }
}


