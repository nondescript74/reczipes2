//
//  KeyView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct KeyView: View {
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    // MARK: - State
    init(apikey: String) {
        UserDefaults.standard.set(apikey, forKey: "SpoonacularKey")
    }
    var body: some View {
        VStack {
            Text("Saved Api Key").font(.largeTitle).bold()
            Divider()
            Text("User supplied key: " + (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "No Key"))
            Divider()
            Button("Press to dismiss") {
                
                dismiss()
            }
        }.padding()
    }
}

struct KeyView_Previews: PreviewProvider {
    static let apikey = "someapikey"
    static var previews: some View {
        KeyView(apikey: apikey)
    }
}
