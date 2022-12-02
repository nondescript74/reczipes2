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
//    @State fileprivate var keyAvailable: Bool = false
    @State fileprivate var apiKey = ""
    // MARK: - Properties
    private enum msgs: String {
        case kv = "KeyView: "
        case key = "Please enter your api key"
    }
    
    fileprivate enum labelz: String {
        case top = "Enter"
        case bot = "ApiKey"
    }
    
    fileprivate enum imagez: String {
        case kv = "greetingcard"
    }
    
    init(apikey: String) {
        UserDefaults.standard.set(apikey, forKey: "SpoonacularKey")
    }
    var body: some View {
        VStack {
            Text("Save Api Key").font(.largeTitle).bold()
            Divider()
            Text("User supplied key: " + (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"))
            Divider()
            HStack {
                Button(action: {
                    // What to perform
                    UserDefaults.standard.set(apiKey, forKey: "SpoonacularKey")
#if DEBUG
                    print(UserDefaults.standard.string(forKey: "SpoonacularKey")!)
#endif
                    
                }) {
                    // How the button looks like
                    RoundButton3View(someTextTop: "Save", someTextBottom: labelz.bot.rawValue, someImage: imagez.kv.rawValue, reversed: false)
                }.disabled(apiKey == "").padding(.bottom)
                
                TextField(msgs.key.rawValue, text: $apiKey)
                
                Button("Dismiss") {
                    dismiss()
                }
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
