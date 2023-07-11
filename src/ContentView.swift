import SwiftUI
import IdsvrHaapiUIKit

struct ContentView: View, HaapiFlowResult {
    
    let haapiApplication: HaapiUIKitApplication
    @State private var oAuthTokenModel: OAuthTokenModel? = nil
    @State private var error: Error? = nil
    @State private var isLoggingIn: Bool = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Demo App")
                    .fontWeight(.bold)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white)
                    .padding(.leading, 10)
            }
            .frame(width: UIScreen.main.bounds.size.width * 1.0, height: 50, alignment: .leading)
            .background(Color.blue)

            Text("Unauthenticated View")
                .foregroundColor(Color.gray)
                .padding(20)
            
            Button {
                isLoggingIn = true
            } label: {
                Text("Start HAAPI Login")
            }
            .frame(width: UIScreen.main.bounds.size.width * 0.8,  height: 40)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(5)
            
            Spacer()
        }
        .sheet(isPresented: $isLoggingIn) {
            
            HaapiFlow.start(
                self,
                haapiUIKitApplication: haapiApplication,
                haapiDeepLinkManageable: HaapiDeepLinkManager.shared)
        }
        .alert("Login completed and tokens received", isPresented: Binding<Bool>.constant(oAuthTokenModel != nil)) {
        } message: {
            Text(oAuthTokenModel?.accessToken ?? "")
        }
        .alert("Problem encountered", isPresented: Binding<Bool>.constant(error != nil)) {
        } message: {
            Text(error?.localizedDescription ?? "")
        }
    }

    func didReceiveOAuthTokenModel(_ oAuthTokenModel: IdsvrHaapiUIKit.OAuthTokenModel) {
        self.oAuthTokenModel = oAuthTokenModel
        self.error = nil
        self.isLoggingIn = false
    }

    func didReceiveError(_ error: Error) {
        self.error = error
        self.oAuthTokenModel = nil
        self.isLoggingIn = false
    }
}


