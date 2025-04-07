import Foundation

struct Configuration {
    static let clientId = "haapi-ios-client"
    static let redirectUri = "haapi://callback"
    static let scopes = ["openid", "profile"]
    static let baseURL = URL(string: "https://localhost:8443")!
    static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
    static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    static let userInfoEndpointURL = URL(string: "/oauth/v2/oauth-userinfo", relativeTo: baseURL)!
    
    static let dcrTemplateClientId: String? = nil
    static let dcrClientRegistrationEndpointPath: String? = nil
    static let deviceSecret: String? = nil
    
    // Uncomment these fields to add support for HAAPI DCR fallback with a simple credential
    //static let dcrTemplateClientId: String? = "haapi-template-client"
    //static let dcrClientRegistrationEndpointPath: String? = "/token-service/oauth-registration"
    //static let deviceSecret: String? = "Password1"
}
