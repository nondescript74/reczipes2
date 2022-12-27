//
//  FridgeEditor.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 9/15/22.
//

import SwiftUI

struct FridgeEditor: View {
    // MARK: - Environment Variables
    @EnvironmentObject var fridge: FridgeContents
    // MARK: - State
    private enum msgs: String {
        case fe = "Fridge"
    }
    var body: some View {
        List {
            Text(msgs.fe.rawValue).bold()
            
            //            Toggle(isOn: $profile.prefersNotifications) {
            //                Text(msgs.enablNotif.rawValue)
            //            } //.disabled(self.prefersNotification == false)
            //
            //            Toggle(isOn: $profile.prefersNutritionInclusion) {
            //                Text(msgs.enablNutr.rawValue)
            //            } //.disabled(self.showingNutrition == false)
            //
            //            Toggle(isOn: $profile.prefersVitaminInclusion) {
            //                Text(msgs.enablVitInSearch.rawValue)
            //            } //.disabled(self.showingVitamins == false)
            //
            //            Toggle(isOn: $profile.loadNewRecipes) {
            //                Text(msgs.loadNewRecip.rawValue)
            //            } //.disabled(self.loadNewRecipes == false)
        }
    }
}

struct FridgeEditor_Previews: PreviewProvider {
    static var previews: some View {
        FridgeEditor()
    }
}
