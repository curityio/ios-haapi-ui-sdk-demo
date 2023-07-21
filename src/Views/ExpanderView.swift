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

public struct ExpanderView <Content, Label> : View
    where Content: View, Label: View
{
    public var label: Label
    public var content: () -> Content
    
    @State private var expanded: Bool

    public init(label: Label, expanded: Bool = false, @ViewBuilder content: @escaping () -> Content)
    {
        self.label = label
        self.content = content
        _expanded = State(initialValue: expanded)
    }

    public var body: some View {
        VStack {
            expanderButton
            if expanded {
                content()
            }
        }
    }
    
    private var expanderButton: some View {
        
        Button(action: {
            withAnimation { self.expanded.toggle() }
        }) {
            HStack {
                
                label
                Spacer()
                if expanded {
                    
                    Image(systemName: "chevron.right.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .rotationEffect(.degrees(270))
                        .frame(width: 50, height: 50, alignment: .topLeading)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("Primary"))
                    
                } else {
                    
                    Image(systemName: "chevron.right.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .rotationEffect(.degrees(90))
                        .frame(width: 50, height: 50, alignment: .topLeading)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("Secondary"))
                }
            }
        }
    }
}
