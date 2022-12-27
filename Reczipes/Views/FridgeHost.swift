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
    @EnvironmentObject var fridge: FridgeContents

    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
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
                FridgeEditor()
                    .onAppear {}
                    .onDisappear {}
            }
        }
        .padding()
    }
    
}

struct FridgeHost_Previews: PreviewProvider {
    static var previews: some View {
        FridgeHost()
            .environmentObject(FridgeContents())
            
    }
}
