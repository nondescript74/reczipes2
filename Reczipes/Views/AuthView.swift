//
//  AuthView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/17/22.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
      SignInWithAppleButton(.continue) { request in
        request.requestedScopes = [.fullName, .email]
      } onCompletion: { result in
        switch result {
          case .success(let authResults):
            print("Authorisation successful")
          case .failure(let error):
            print("Authorisation failed: \(error.localizedDescription)")
        }
      }.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
//      // black button
//      .signInWithAppleButtonStyle(.black)
//      // white button
//      .signInWithAppleButtonStyle(.white)
//      // white with border
//      .signInWithAppleButtonStyle(.whiteOutline)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
// https://developer.apple.com/forums/thread/656784
