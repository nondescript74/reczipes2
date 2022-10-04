//
//  SettingsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/18/22.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Debug
    private var zBug:Bool = false
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    // MARK: - ObservedObject
    @ObservedObject var trivia = WebQueryRecipes()
    @ObservedObject var joke = WebQueryRecipes()
    // MARK: - State
    @State private var show: Selectors = .notyet
    // MARK: - Properties
    private var versionLabel = ""
    private var buildLabel = ""
    private enum msgs:String {
        case sv = "User Settings"
        case cfsv = "CFBundleShortVersionString"
        case cfb = "CFBundleVersion"
        case z = "Hello, Z"
        case vers = "Version: "
        case build = "Build: "
        case nvn = "No Version #???"
        case nbn = "No Build #???"
        case makeSelection = "Click Joke or Trivia"
        case noTitle = "No Recipe Title"
        case signout = "rectangle.stack.badge.person.crop"
        
    }
    enum labelz: String {
        case get = "Get"
    }
    enum Selectors {
        case notyet
    }
    // MARK: - Methods
    var body: some View {
        
        NavigationView {
            VStack {
                VStack {
                    Text(msgs.sv.rawValue).font(.largeTitle).bold()
                    Text(msgs.vers.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfsv.rawValue] as? String ?? msgs.nvn.rawValue)")
                    Text(msgs.build.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfb.rawValue] as? String ?? msgs.nbn.rawValue)")
                    Text(userData.profile.username)
                    Text(userData.profile.email)
                }.padding(.bottom)
                
                VStack() {
                    NavigationLink(destination: AuthView()) {
                        Text("Sign in with Apple")
                    }.padding(.bottom)
                    
                    NavigationLink(destination: FilesDisplayView()) {
                        Text("Display user saved recipes, notes, images")
                    }.padding(.bottom)
                    
                    NavigationLink(destination: ProfileHost()) {
                        Text("View/Edit User profile settings")
                    }.padding(.bottom)
                    
                    NavigationLink(destination: NutritionHost()) {
                        Text("View/Edit user nutrition settings")
                    }.padding(.bottom)
                    NavigationLink(destination: KeyView(apikey: UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")) {
                        Text("Set user api key")
                    }.padding(.bottom)
                }
                
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let userdata = UserData()
    static var previews: some View {
        SettingsView()
            .environmentObject(userdata)
    }
}
