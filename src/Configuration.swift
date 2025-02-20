import Foundation

struct Configuration {
    static let clientId = "haapi-ios-client"
    static let redirectUri = "haapi://callback"
    static let scopes = ["openid", "profile"]
    static let baseURL = URL(string: "https://localhost:8443")!
    static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
    static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    static let userInfoEndpointURL = URL(string: "/oauth/v2/oauth-userinfo", relativeTo: baseURL)!
}
