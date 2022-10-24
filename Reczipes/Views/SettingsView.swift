//
//  SettingsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/18/22.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Debug
    private var zBug:Bool = true
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    // MARK: - ObservedObject
    @ObservedObject var trivia = WebQueryRecipes()
    @ObservedObject var joke = WebQueryRecipes()
    // MARK: - State
    @State private var show: Selectors = .notyet
    @State private var showRemove = false
    // MARK: - Properties
    private var versionLabel = ""
    private var buildLabel = ""
    private enum msgs:String {
        case sv = "User Settings: "
        case cfsv = "CFBundleShortVersionString"
        case cfb = "CFBundleVersion"
        case z = "Hello, Z"
        case vers = "Version: "
        case build = "Build: "
        case nvn = "No Version #???"
        case nbn = "No Build #???"
        //        case makeSelection = "Click Joke or Trivia"
        case noTitle = "No Recipe Title"
        //        case signout = "rectangle.stack.badge.person.crop"
        case remov = "removed all user recipes"
        
    }
    enum labelz: String {
        case get = "Get"
    }
    enum Selectors {
        case notyet
    }
    // MARK: - Methods
    fileprivate func removeMyAddedRecipes() {
        DispatchQueue.main.async {
            FileManager.default.removeAddedRecipes()
        }
#if DEBUG
        if zBug {print(msgs.sv.rawValue + msgs.remov.rawValue)}
#endif
        showRemove = false
    }
    
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
                
                VStack {
                    MultiView(show: .notyet)
                }
                
                VStack {
                    Button("Tap to remove user recipes") {
                        showRemove = true
                    }.buttonStyle(.borderedProminent)
                }
                
            }.padding(.bottom)
            .actionSheet(isPresented: $showRemove) {
                ActionSheet(title: Text("Remove All User Recipes"),
                            message: Text("Choose"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("Remove Recipes"),
                                    action: removeMyAddedRecipes
                                )
                            ]
                )
            }
        }.navigationBarTitleDisplayMode(.automatic)
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let userdata = UserData()
    static var previews: some View {
        SettingsView()
            .environmentObject(userdata)
    }
}
