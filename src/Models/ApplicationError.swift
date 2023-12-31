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

import IdsvrHaapiUIKit

class ApplicationError: Error {

    let title: String
    let description: String
    let code: String?

    init(title: String, description: String, code:String? = nil) {
        self.title = title
        self.description = description.isEmpty ? "Operation failed" : description
        self.code = code
    }

    public func getDetails() -> String {
        
        var details = "";
        if self.code != nil {
            details += "\(self.code!), "
        }
        details += self.description
        return details
    }
}
