//
//  AuthView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/17/22.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    // MARK: - State
    @State private var notauthenicated: Bool = false
    @State private var authenicated: Bool = false
    // MARK: - Methods
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alertController.present(alertController, animated: true)
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.headydiscy.reczipes", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // Create an account in your system.
                        let userIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let email = appleIDCredential.email
                        userData.profile.username = (fullName?.givenName ?? "No given name") + " " + (fullName?.familyName ?? "No family name")
                        
                        self.saveUserInKeychain(userIdentifier)
                        userData.profile.id = userIdentifier
                        userData.profile.email = email ?? "noone@gmail.com"
                        notauthenicated = false
                        authenicated = true
                        
                        
                    case let passwordCredential as ASPasswordCredential:
                            // Sign in using an existing iCloud Keychain credential.
                            let username = passwordCredential.user
                            let password = passwordCredential.password
                            
                            // For the purpose of this demo app, show the password credential as an alert.
                            DispatchQueue.main.async {
                                self.showPasswordCredentialAlert(username: username, password: password)
                            }
                    default:
                        break
                    }
                case .failure(let error):
                    print("Authorisation failed: \(error.localizedDescription)")
                    notauthenicated = true
                    authenicated = false
                }
            }.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .alert(isPresented: $notauthenicated)   {
                    return Alert(title: Text("Authenication"), message: Text("Failed"), dismissButton: .default(Text("Ok")))
                }
                .alert(isPresented: $authenicated)   {
                    return Alert(title: Text("Authenication"), message: Text("Success"), dismissButton: .default(Text("Ok")))
                }
        }.padding()
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
// https://developer.apple.com/forums/thread/656784
