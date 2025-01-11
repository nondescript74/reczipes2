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
            Text("Recipe contains \(self.cRecipe.usedIngredients.count) ingredients")
            ForEach(self.cRecipe.usedIngredients) { ingredient in
                Text("\(ingredient.name)")
            }
        }.padding()
    }
}

#Preview {
    RecipeByIngredientsView(cRecipe: CRecipe.example)
}
