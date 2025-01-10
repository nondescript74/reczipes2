//
//  ExtendendIngredientsView2.swift
//  ZTester4
//
//  Created by Zahirudeen Premji on 08/22/2021.
//

import SwiftUI

struct ExtendendIngredientsView2: View {
    @EnvironmentObject var ratio: RecipeRatio
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    // MARK: - Initializer
    init(sectionitem: SectionItem3) {
        extractedSRecipe.findExtracted(urlString: sectionitem.url)
#if DEBUG
        print(sectionitem.name, sectionitem.url, sectionitem.imageUrl, sectionitem.recipeId ?? "-1")
#endif

    }
    // MARK: - Properties
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(extractedSRecipe.extractedSRecipe?.extendedIngredients ?? [ExtendedIngredient.extendedIngredientExample], id: \.self) { extIng in
                    ExtendedIngredView(extendedIngredient: extIng!)
                }.disabled(extractedSRecipe.extractedSRecipe?.extendedIngredients == nil)
                    .padding([.top, .bottom])
            }
            .environmentObject(ratio)
        }
        
    }
}


struct ExtendendIngredientsView2_Previews: PreviewProvider {
    static var previews: some View {
        ExtendendIngredientsView2(sectionitem: SectionItem3.example)
            .environmentObject(RecipeRatio())
             
    }
}

