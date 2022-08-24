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
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userData: UserData
    // MARK: - Properties
    private var versionLabel = ""
    private var buildLabel = ""
    fileprivate enum msgs:String {
        case sv = "User Settings View"
        case cfsv = "CFBundleShortVersionString"
        case cfb = "CFBundleVersion"
        case z = "Hello, Z"
        case vers = "Version: "
        case build = "Build: "
        case nvn = "No Version #???"
        case nbn = "No Build #???"
    }
    // MARK: - Methods
    var body: some View {
        VStack {
            Text(msgs.sv.rawValue).font(.largeTitle).bold()
            Text(msgs.vers.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfsv.rawValue] as? String ?? msgs.nvn.rawValue)")
            Text(msgs.build.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfb.rawValue] as? String ?? msgs.nbn.rawValue)")
            
            ProfileHost().padding()
            NutritionHost().padding()
            ATestView().padding()
        }
            }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
