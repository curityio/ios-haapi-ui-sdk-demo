import SwiftUI
import IdsvrHaapiUIKit

@main
struct DemoApp: App {
    
    @UIApplicationDelegateAdaptor(DemoAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(haapiApplication: appDelegate.haapiUIKitApplication)
                .onOpenURL(perform: handleUrl(url:))
        }
    }
    
    func handleUrl(url: URL) {
        if HaapiDeepLinkManager.shared.canHandleUrl(url) {
            HaapiDeepLinkManager.shared.handleUrl(url)
        }
    }
}

