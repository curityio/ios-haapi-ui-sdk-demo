import Foundation

struct Configuration {
    static let clientId = "haapi-ios-dev-client"
    static let redirectUri = "haapi:start"
    static let scopes = ["openid", "profile"]
    static let baseURL = URL(string: "https://e42c-2a00-23c7-8eb9-f801-d88-5c06-6eea-a83c.ngrok-free.app")!
    static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
    static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    static let userInfoEndpointURL = URL(string: "/oauth/v2/oauth-userinfo", relativeTo: baseURL)!
}
