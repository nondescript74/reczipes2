//
//  KeyView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct KeyView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false 
    // MARK: - Initializer
    // MARK: - Environment Variables
    // MARK: - State
    @State fileprivate var apiKey: String = ""
    // MARK: - Properties
    private enum msgs: String {
        case kv = "KeyView: "
        case kvset = "apiKey set "
        case key = "Please enter your api key"
        case ksave = "Save Api Key"
        case kx = "key: "
        case kno = "No Key"
        case kdidnot = "did not set key"
    }
    
    fileprivate enum labelz: String {
        case top = "Save"
        case bot = "ApiKey"
    }
    
    fileprivate enum imagez: String {
        case kv = "key"
    }
    
    // MARK: - Methods
    @MainActor
    fileprivate func setApiKey(key: String) {
        if apiKey.isEmpty ||  apiKey == UserDefaults.standard.string(forKey: skey) {
            apiKey = ""
#if DEBUG
            if zBug {print(msgs.kv.rawValue + msgs.kdidnot.rawValue)}
#endif
            return
        }
        DispatchQueue.main.async {
            UserDefaults.standard.set(apiKey, forKey: skey)
            apiKey = ""
#if DEBUG
            if zBug {print(msgs.kv.rawValue + msgs.kvset.rawValue + UserDefaults.standard.string(forKey: skey)!)}
#endif
        }
        
        
    }
    // MARK: - View process
    
    var body: some View {
        VStack {
            Text(msgs.ksave.rawValue).font(.largeTitle).bold()
            List {
                Text(UserDefaults.standard.string(forKey: skey) != "" ? "key set" : "key not set")
//                Text(msgs.kx.rawValue +  (UserDefaults.standard.string(forKey: skey) ?? msgs.kno.rawValue))
                
                HStack {
                    Button(action: {
                        // What to perform
                        setApiKey(key: apiKey)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.top.rawValue, someTextBottom: labelz.bot.rawValue, someImage: imagez.kv.rawValue, reversed: false)
                    }.disabled(apiKey.isEmpty).padding(.bottom)
                    
                    TextField(msgs.key.rawValue, text: $apiKey)
                }
            }
        }
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
