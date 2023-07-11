import SwiftUI

/*
 * For use only in development environments, to allow connections to https://localhost:8443
 */
class TrustAllCertsDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        var credential: URLCredential?
        let serverTrust = challenge.protectionSpace.serverTrust
        if let serverTrust = serverTrust {
            credential = URLCredential(trust: serverTrust)
        }

        completionHandler(.useCredential, credential)
    }
}
