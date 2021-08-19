//
//  PlusSignView.swift
//  PlusSignView
//
//  Created by Zahirudeen Premji on 8/17/21.
//

import SwiftUI

struct PlusSignView: View {
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case psv = "PlusSignView"
        case plus = "+"
        case writingRecipe = "Adding Recipe"
    }
    // MARK: - Methods
    private func performAddRecipeToAddedRecipes() {
#if DEBUG
                print(msgs.psv.rawValue + msgs.writingRecipe.rawValue)
#endif
    }
    var body: some View {
        Button(action: {
            // What to perform
            performAddRecipeToAddedRecipes()
        }) {
            // How the button looks like
            Text(msgs.plus.rawValue)
                .foregroundColor(.blue)
                .font(Font.system(size: 45, weight: .medium, design: .serif))
                
        }
        .padding()
        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
    }
}

struct PlusSignView_Previews: PreviewProvider {
    static var previews: some View {
        PlusSignView()
    }
}
