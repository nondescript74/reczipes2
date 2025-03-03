//
//  ExtendendIngredientsView2.swift
//  ZTester4
//
//  Created by Zahirudeen Premji on 08/22/2021.
//

import SwiftUI

struct ExtendendIngredientsView2: View {
    @Environment(RecipeRatio.self) private var ratio
    // MARK: - ObservedObject
    var extractedSRecipe = WebQueryRecipes()
    // MARK: - Initializer
    init(sectionitem: SectionItem3) {
        extractedSRecipe.findExtracted(urlString: sectionitem.url)
#if DEBUG
        print("ExtIngView2 SI name: ", sectionitem.name, "ExtIngView2 SI url: ", sectionitem.url, "ExtIngView2 SI image: ", sectionitem.imageUrl ?? ExtendedIngredient.extendedIngredientExample.image!, "ExtIngView2 SI recipeId: ", sectionitem.recipeId ?? "-1")
#endif

    }

    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(extractedSRecipe.extractedSRecipe?.extendedIngredients ?? [ExtendedIngredient.extendedIngredientExample], id: \.self) { extIng in
                    ExtendedIngredView(extendedIngredient: extIng!)
                }.disabled(extractedSRecipe.extractedSRecipe?.extendedIngredients == nil)
                    .padding([.top, .bottom])
            }
        }
        .environment(ratio)
        
    }
}


struct ExtendendIngredientsView2_Previews: PreviewProvider {
    static var previews: some View {
        ExtendendIngredientsView2(sectionitem: SectionItem3.example)
            .environment(RecipeRatio())
             
    }
}

