//
//  ShowRestrExplView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/30/22.
//

import SwiftUI

struct ShowRestrExplView: View {
    @EnvironmentObject var rbb: RecipeBeingBuilt
    fileprivate func getRestrictions() -> [String] {
        var myReturn: [String] = rbb.sectionItem?.restrictions ?? ["no restrictions"]
        return myReturn
    }
    var body: some View {
        ForEach(getRestrictions(), id: \.self) { name in
            Text(name)
        }
    }
}

struct ShowRestrExplView_Previews: PreviewProvider {
    static var previews: some View {
        ShowRestrExplView()
    }
}
