//
//  KeyView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct KeyView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Initializer
//    init(apikey: String) {
//        UserDefaults.standard.set(apikey, forKey: "SpoonacularKey")
//    }
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    // MARK: - State
    @State fileprivate var apiKey = ""
    // MARK: - Properties
    private enum msgs: String {
        case kv = "KeyView: "
        case kvset = "apiKey set "
        case key = "Please enter your api key"
    }
    
    fileprivate enum labelz: String {
        case top = "Enter"
        case bot = "ApiKey"
    }
    
    fileprivate enum imagez: String {
        case kv = "greetingcard"
    }

    // MARK: - Methods
    @MainActor
    fileprivate func setApiKey(key: String) {
        if apiKey == "" {
            return
        }
        userData.change(setapikey: key)
         
    }
    // MARK: - View process

    var body: some View {
        NavigationView {
            VStack {
                Text("Save Api Key").font(.largeTitle).bold()
                List {
                    Text("key: " +  userData.apikey)
                    
                    HStack {
                        Button(action: {
                            // What to perform
                            setApiKey(key: apiKey)
#if DEBUG
                            if zBug {print(msgs.kv.rawValue + msgs.kvset.rawValue + userData.apikey)}
#endif
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: "Save", someTextBottom: labelz.bot.rawValue, someImage: imagez.kv.rawValue, reversed: false)
                        }.disabled(apiKey == "").padding(.bottom)
                        
                        TextField(msgs.key.rawValue, text: $apiKey)
                    }
                }
            }
        }
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
            .environmentObject(UserData())
    }
}
