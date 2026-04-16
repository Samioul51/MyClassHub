//
//  GmailAuthService.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import Foundation
import FirebaseCore
import GoogleSignIn

class GmailAuthService: ObservableObject {

    private let tokenKey = "gmail_access_token"
    private let emailKey = "gmail_connected_email"

    // MARK: - Stored Credentials

    var storedAccessToken: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }

    var storedEmail: String? {
        get { UserDefaults.standard.string(forKey: emailKey) }
        set { UserDefaults.standard.set(newValue, forKey: emailKey) }
    }

    // MARK: - Sign In

    func startOAuthFlow(
        presentingViewController: UIViewController,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // Clear any previous session first
        GIDSignIn.sharedInstance.signOut()

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(
                domain: "GmailAuth",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Missing Firebase clientID"]
            )))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(NSError(
                    domain: "GmailAuth",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Could not retrieve user"]
                )))
                return
            }

            // Request Gmail scope after sign in
            user.addScopes(
                ["https://www.googleapis.com/auth/gmail.readonly"],
                presenting: presentingViewController
            ) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard
                    let accessToken = user.accessToken.tokenString as String?,
                    let email       = user.profile?.email
                else {
                    completion(.failure(NSError(
                        domain: "GmailAuth",
                        code: -3,
                        userInfo: [NSLocalizedDescriptionKey: "Could not retrieve token or email"]
                    )))
                    return
                }

                // No Firebase Auth sign in — just store token
                self?.storedAccessToken = accessToken
                self?.storedEmail       = email
                completion(.success(accessToken))
            }
        }
    }

    // MARK: - Logout

    func logout() {
        GIDSignIn.sharedInstance.signOut()
        storedAccessToken = nil
        storedEmail       = nil
    }
}
