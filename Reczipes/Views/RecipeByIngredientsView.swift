//
//  RecipeByIngredientsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 8/30/24.
//

import SwiftUI

struct RecipeByIngredientsView: View {
    
    // MARK: - ObservedObject
    //MARK: - Environment
    @EnvironmentObject var swri: SRecipeWithInfo
    
    init(cRecipe: CRecipe) {
        self.cRecipe = cRecipe
//        await swri.executeQuery(recipeId: cRecipe.id)
    }
    
    private var cRecipe: CRecipe
    
    private func executeTheQuery() async {
        await swri.executeQuery(recipeId: cRecipe.id)
    }
    var body: some View {
//        NavigationLink(destination: RecipeDetailView(imageString: CRecipe.image, sectionItem: convertSRecipeToSectionItem3(srecipe: swri.result), cuisine: (swri.result.cuisines?.first)!!)) {
//            
            VStack(alignment: .leading) {
                Text(self.cRecipe.title)
                Text(self.cRecipe.id.description)
            }.padding()
            
//        }
        
    }
}

#Preview {
    RecipeByIngredientsView(cRecipe: CRecipe.cRecipeExample)
}
