import SwiftUI
import IdsvrHaapiUIKit

struct ContentView: View, HaapiFlowResult {
    
    let haapiApplication: HaapiUIKitApplication
    @State private var loggingIn = false
    @State private var oAuthTokenModel: OAuthTokenModel? = nil
    @State private var error: Error? = nil
    
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
                loggingIn = true
            } label: {
                Text("Start HAAPI Login")
            }
            .frame(width: UIScreen.main.bounds.size.width * 0.8,  height: 40)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(5)
            
            Spacer()
        }
        .sheet(isPresented: $loggingIn) {
            
            HaapiFlow.start(
                self,
                haapiUIKitApplication: haapiApplication,
                haapiDeepLinkManageable: HaapiDeepLinkManager.shared)
        }
        .alert(isPresented: Binding<Bool>.constant(error != nil)) {
            
            Alert(title: Text("Problem encountered"),
                  message: Text(error?.localizedDescription ?? ""),
                  dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: Binding<Bool>.constant(oAuthTokenModel != nil)) {
            
            Alert(title: Text("Login completed and tokens received"),
                  message: Text(oAuthTokenModel?.accessToken ?? ""),
                  dismissButton: .default(Text("OK"))
            )
        }
    }

    func didReceiveOAuthTokenModel(_ oAuthTokenModel: IdsvrHaapiUIKit.OAuthTokenModel) {
        loggingIn = false
        self.oAuthTokenModel = oAuthTokenModel
        self.error = nil
    }

    func didReceiveError(_ error: Error) {
        loggingIn = false
        self.error = error
        self.oAuthTokenModel = nil
    }
}


