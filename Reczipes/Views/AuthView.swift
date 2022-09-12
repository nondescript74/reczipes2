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
                        userData.profile.id = userIdentifier
                        notauthenicated = false
                        authenicated = true
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
