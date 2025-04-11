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

import UIKit
import IdsvrHaapiUIKit

/*
 * Demonstrates replacing an entire screen with a completely custom layout
 * This example renders the authentication selection screen in a custom way
 * Passkeys are rendered first to encourage users to choose a modern and secure login method
 */
class AuthenticationSelectionViewController: UIViewController, HaapiUIViewController {
    
    var haapiFlowViewControllerDelegate: HaapiFlowViewControllerDelegate?
    var uiStylableThemeDelegate: UIStylableThemeDelegate?
    var model: SelectorModel
 
    lazy var content: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: SelectorModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    /*
     * Render a header followed by authentication selection items
     * Each item is a heading and a button
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(content)
        
        let contentConstraints: [NSLayoutConstraint] = [
            content.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            content.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(contentConstraints)
        
        let header = UILabel(frame: .zero)
        header.text = "Choose a Login Method"
        header.font = UIFont.boldSystemFont(ofSize: 24)
        header.textColor = UIColor(named: "Primary")
        header.textAlignment = .center
        content.addArrangedSubview(header)
        let headerConstraints: [NSLayoutConstraint] = [
            header.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 30),
            header.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: -30),
            header.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(headerConstraints)
        
        var authenticators = model.selectorItems
            .compactMap { $0 as? SelectorItemInteractionActionModel }
        
        authenticators
            .sort {
                let first  = $0.type ?? ""
                let second = $1.type ?? ""
                if first == "passkeys" { return true }
                if second == "passkeys" { return false }
                return first < second
            }
        
        authenticators.forEach({item in
            renderAuthenticator(item: item)
        })
    }
    
    func onAction() {
    }
    
    func stopLoading() {
    }
    
    func hasLoading() -> Bool {
        return false
    }
    
    func handleProblemModel(_ problemModel: ProblemModel) -> Bool {
        return false
    }
    
    func handleInfoMessageModels(_ infoMessageModels: [InfoMessageModel]) {
    }
    
    func handleLinkItemModels(_ linkItemModels: [any LinkItemModel]) {
    }
    
    func handleFormModel(_ formModel: FormModel) -> Bool {
        return false
    }
    
    func hideHeaderView() {
    }
    
    func preSubmit(interactionActionModel: any IdsvrHaapiUIKit.InteractionActionModel, parameters: [String: Any], closure: (Bool, [String: Any]) -> Void) {
        closure(true, parameters)
    }
        
    func preSelect(selectorItemModel: any IdsvrHaapiUIKit.SelectorItemInteractionActionModel, closure: (Bool) -> Void) {
        closure(true)
    }
        
    func preFollow(linkItemModel: any IdsvrHaapiUIKit.LinkItemModel, closure: (Bool) -> Void) {
        closure(true)
    }
    
    private func renderAuthenticator(item: SelectorItemInteractionActionModel) {
        
        let itemType = item.type ?? ""
        if item.action is FormActionModel {
            
            let label = AuthenticationSelectorLabel(authenticatorType: itemType)
            content.addArrangedSubview(label)
            let lblConstraints: [NSLayoutConstraint] = [
                label.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 30),
                label.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: -30)
            ]
            NSLayoutConstraint.activate(lblConstraints)
            
            let button = AuthenticationSelectorButton(model: item)
            button.addTarget(self, action: #selector(onAuthenticatorSelected(_:)), for: .touchUpInside)
            content.addArrangedSubview(button)
            let btnConstraints: [NSLayoutConstraint] = [
                button.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 30),
                button.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: -30),
                button.heightAnchor.constraint(equalToConstant: 48),
            ]
            NSLayoutConstraint.activate(btnConstraints)
        }
    }
    
    /*
     * The custom view must submit the correct authentication selection to the server
     */
    @objc private func onAuthenticatorSelected(_ sender: AuthenticationSelectorButton) {
        let parameters: [String: String] = [:]
        self.haapiFlowViewControllerDelegate?.submit(interactionActionModel: sender.getModel(), parameters: parameters)
    }
}
