import Foundation

struct Configuration {
    static let clientId = "haapi-ios-dev-client"
    static let redirectUri = "haapi:start"
    static let scopes = ["openid", "profile"]
    static let baseURL = URL(string: "http://localhost:8443")!
    static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
    static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    static let userInfoEndpointURL = URL(string: "/oauth/v2/oauth-userinfoxxx", relativeTo: baseURL)!
}
