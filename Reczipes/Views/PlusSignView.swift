//
//  PlusSignView.swift
//  PlusSignView
//
//  Created by Zahirudeen Premji on 8/17/21.
//

import SwiftUI

struct PlusSignView: View {
    
    // MARK: - Initializer
    init(sectionItem: SectionItem) {
        self.myRecipe = sectionItem
    }
    
    // MARK: - EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    
    // MARK: - Properties
    private var myRecipe: SectionItem
    private enum msgs: String {
        case psv = "PlusSignView"
        case plus = "+"
        case writingRecipe = "Adding Recipe"
    }
    
    // MARK: - Methods
    private func performAddRecipeToAddedRecipes() {
        #if DEBUG
            print(msgs.psv.rawValue + msgs.writingRecipe.rawValue)
        #endif
        //addedRecipes.a
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
        PlusSignView(sectionItem: SectionItem.example)
    }
}
