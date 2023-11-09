import Foundation

struct Configuration {
    static let clientId = "haapi-ios-dev-client"
    static let redirectUri = "haapi:start"
    static let scopes = ["openid", "profile"]
    static let baseURL = URL(string: "https://a21b-2a00-23c7-8ec3-2401-dc5c-f19a-9b0c-c58.ngrok-free.app")!
    static let tokenEndpointURL = URL(string: "/oauth/v2/oauth-token", relativeTo: baseURL)!
    static let authorizationEndpointURL = URL(string: "/oauth/v2/oauth-authorize", relativeTo: baseURL)!
    static let userInfoEndpointURL = URL(string: "/oauth/v2/oauth-userinfo", relativeTo: baseURL)!
}
