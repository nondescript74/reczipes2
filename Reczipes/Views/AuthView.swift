//
//  AuthView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/17/22.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Environment
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    // MARK: - Initializer
    // MARK: - State
//    @State private var notauthenicated: Bool = false
//    @State private var authenicated: Bool = false
    // MARK: - Properties
    fileprivate enum msgs: String {
        case service = "com.headydiscy.reczipes"
        case ui = "userIdentifier"
        case suikfs = "saved userIdentifier in keychain for service: "
        case retrieved = "retrieved userIdentifier in keychain for service: "
        case unable = "Unable to save userIdentifier to keychain."
        case sid = "Sample ID"
    }
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
            try KeychainItem(service: msgs.service.rawValue, account: msgs.ui.rawValue).saveItem(userIdentifier)
            if zBug {print(msgs.suikfs.rawValue, msgs.service.rawValue)}
            let zKCI = try KeychainItem(service: msgs.service.rawValue, account: msgs.ui.rawValue).readItem()
            if zBug {print(msgs.retrieved.rawValue, msgs.service.rawValue, zKCI)}
        } catch {
            print(msgs.unable.rawValue)
        }
    }
    
    fileprivate func signOut(userIdentifier: String) {
        do {
            try KeychainItem(service: msgs.service.rawValue, account: msgs.ui.rawValue).deleteItem()
            if zBug {print("signed out")}
            userData.profile.id = msgs.sid.rawValue
        } catch {
            if zBug {print("signing out error")}
        }
    }
    
    var body: some View {
        VStack {
            Text("Sign in").font(.largeTitle).bold()
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // Create an account in your system.
                        let userIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let givenName = fullName?.givenName
                        let familyName = fullName?.familyName
                        let email = appleIDCredential.email
                        userData.profile.username = (givenName ?? "No given name") + " " + (familyName ?? "No family name")
                        
                        self.saveUserInKeychain(userIdentifier)
                        userData.profile.id = userIdentifier
                        userData.profile.email = email ?? "noone@gmail.com"
//                        notauthenicated = false
//                        authenicated = true
                        
                        
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
                    break
//                    notauthenicated = true
//                    authenicated = false
                }
            }.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(minWidth: 140, idealWidth: 200, maxWidth: 250, minHeight: 50, idealHeight: 50, maxHeight: 60)
            
            Button(action: {
                // What to perform
                signOut(userIdentifier: userData.profile.id)

            }) {
                // How the button looks like
                 Text("Sign Out")
            }
            
        }.padding()
//            .alert(isPresented: $notauthenicated)   {
//                return Alert(title: Text("Authenication"), message: Text("Failed"), dismissButton: .default(Text("Ok")))
//            }
//            .alert(isPresented: $authenicated)   {
//                return Alert(title: Text("Authenication"), message: Text("Success"), dismissButton: .default(Text("Ok")))
//            }
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(UserData())
    }
}
/* https://developer.apple.com/forums/thread/656784
 https://developer.apple.com/design/human-interface-guidelines/technologies/sign-in-with-apple#sign-in-with-apple-buttons
 */
