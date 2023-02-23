/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view that hosts the profile viewer and editor.
 */

import SwiftUI
import CoreData

struct ProfileHost: View {
    // MARK:- Environment
    @Environment(\.editMode) var mode
    @EnvironmentObject var userData: UserData
    // MARK: - ManagedObjectContext
    //MARK: - State
    @State fileprivate var draftProfile = Profile.default
    // MARK: - View Process
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
                     
                
            }
            if self.mode?.wrappedValue == .inactive {
                ProfileSummary(profile: userData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        self.draftProfile = self.userData.profile
                    }
                    .onDisappear {
                        self.userData.profile = self.draftProfile
                    }
            }
        }
    }
}


struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(UserData())
            .environment(\.editMode, Binding.constant(EditMode.active))
    }
}

