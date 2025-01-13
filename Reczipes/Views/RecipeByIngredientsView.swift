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
#if DEBUG
        print("RecByIng, title and id : ", cRecipe.title, cRecipe.id)
#endif

    }
    fileprivate var cRecipe: CRecipe
    
    var body: some View {
        VStack(alignment: .center) {
            Text(self.cRecipe.title)
            Text(self.cRecipe.id.description)
            AsyncImage(url: URL(string: cRecipe.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .accessibility(hidden: false)
                        .accessibilityLabel(Text(cRecipe.title))
                } else {
                    ProgressView()
                }
            }
            Text("Recipe contains \(self.cRecipe.usedIngredients.count + self.cRecipe.missedIngredients.count) ingredients")
            ForEach(self.cRecipe.usedIngredients) { ingredient in
                Text("\(ingredient.name)")
            }
            ForEach(self.cRecipe.missedIngredients) {ingredient in
                Text("\(ingredient.name)")
            }.disabled(self.cRecipe.missedIngredients.count == 0)
        }.padding()
    }
}

#Preview {
    RecipeByIngredientsView(cRecipe: CRecipe.example)
}
