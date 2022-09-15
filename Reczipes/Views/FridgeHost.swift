//
//  FridgeHost.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 9/15/22.
//

import SwiftUI

struct FridgeHost: View {
    // MARK:- Environment
    @Environment(\.editMode) var mode
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var fridge: MyFridge
    // MARK: - ManagedObjectContext
    //MARK: - State
    @State fileprivate var draftFridge = MyFridge.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftFridge = MyFridge.default
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
                    .onAppear {}
                    .onDisappear {}
                
            }
            if self.mode?.wrappedValue == .inactive {
                FridgeSummary()
            } else {
//                FridgeEditor(fridge: $draftFridge.de)
//                    .onAppear {
//                        self.draftFridge = fridge
//                    }
//                    .onDisappear {
//                        self.draftFridge = self.draftProfile
//                    }
            }
        }
        .padding()
    }
    
}

struct FridgeHost_Previews: PreviewProvider {
    static var previews: some View {
        FridgeHost()
    }
}
