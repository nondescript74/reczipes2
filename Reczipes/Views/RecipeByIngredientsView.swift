//
//  RecipeByIngredientsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 8/30/24.
//

import SwiftUI

struct RecipeByIngredientsView: View {
    
    init(cRecipe: CRecipe) {
        self.cRecipe = cRecipe
    }
    
    private var cRecipe: CRecipe
    var body: some View {
        NavigationLink(destination: RecipeDetailView(imageString: cRecipe.image, sectionItem: convertCRecipeToSectionItem3(crecipe: cRecipe), cuisine: "No cuisine")) {
            
            VStack(alignment: .leading) {
                Text(self.cRecipe.title)
                Text(self.cRecipe.id.description)
            }.padding()
            
        }
        
    }
}

#Preview {
    RecipeByIngredientsView(cRecipe: CRecipe.cRecipeExample)
}
