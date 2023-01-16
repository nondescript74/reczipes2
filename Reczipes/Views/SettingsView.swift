//
//  SettingsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/18/22.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Debug
    private var zBug: Bool = false
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
        case sv = "User Settings: "
        case cfsv = "CFBundleShortVersionString"
        case cfb = "CFBundleVersion"
        case z = "Hello, Z"
        case vers = "Version: "
        case build = "Build: "
        case nvn = "No Version #???"
        case nbn = "No Build #???"
        case noTitle = "No Recipe Title"
        case remov = "removed all user recipes"
        
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
                    Text(msgs.sv.rawValue).font(.largeTitle).bold()
                    Text(msgs.vers.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfsv.rawValue] as? String ?? msgs.nvn.rawValue)")
                    Text(msgs.build.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfb.rawValue] as? String ?? msgs.nbn.rawValue)")
                    Text(userData.profile.username)
                    Text(userData.profile.email)
            }.padding(.bottom)
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
