//
//  VitaminHost.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 6/14/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI
import CoreData

struct VitaminHost: View {
    // MARK; - Debug
    fileprivate var zBug: Bool = false
    
    // MARK:- Environment
    @Environment(\.editMode) var mode
    @Environment(UserData.self) private var userData

    //MARK: - State
    @State var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.userData.profile
                        self.mode?.animation().wrappedValue = .inactive
                        
                    }
                }
                
                Spacer()
                
                EditButton()
                    .onAppear {
                        if self.zBug {print("Onappear draftProfile: ", self.draftProfile, " userData.profile: ", self.userData.profile)}}
                    .onDisappear {
                        if self.zBug {print("OnDisappear draftProfile: ", self.draftProfile, " userData.profile: ", self.userData.profile)}}
                
            }
            if self.mode?.wrappedValue == .inactive {
                ProfileSummary(profile: userData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        if self.zBug {print("Before draftProfile: ", self.draftProfile, " userData.profile: ", self.userData.profile)}
                        self.draftProfile = self.userData.profile
                }
                .onDisappear {
                    self.userData.profile = self.draftProfile
                    if self.zBug {print("After draftProfile: ", self.draftProfile, " userData.profile: ", self.userData.profile)}
                }
            }
        }
        .padding()
        .environment(userData)

    }
}

struct VitaminHost_Previews: PreviewProvider {
    static var previews: some View {
        VitaminHost()
            .environment(UserData())
            .environment(AllUserImages())
            .environment(AllUserNotes())
    }
}

