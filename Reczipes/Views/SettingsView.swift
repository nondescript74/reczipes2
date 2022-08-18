//
//  SettingsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/18/22.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Debug
    private var zBug: Bool = true
    // MARK: - Properties
    private var versionLabel = ""
    private var buildLabel = ""
    // MARK: - Methods
    var body: some View {
        VStack {
            Text("Hello Z!")
            Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "No Version Number ???")")
            Text("Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "No Build Number ???")")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
