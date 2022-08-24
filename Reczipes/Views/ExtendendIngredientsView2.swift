//
//  ExtendendIngredientsView2.swift
//  ZTester4
//
//  Created by Zahirudeen Premji on 08/22/2021.
//

import SwiftUI

struct ExtendendIngredientsView2: View {
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    // MARK: - Initializer
    init(sectionitem: SectionItem) {  //
        extractedSRecipe.findExtracted(urlString: sectionitem.url)
    }
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(extractedSRecipe.extractedSRecipe?.extendedIngredients ?? [ExtendedIngredient.extendedIngredientExample], id: \.self) { extIng in
                    ExtendedIngredView(extendedIngredient: extIng!)
                }.disabled(extractedSRecipe.extractedSRecipe?.extendedIngredients == nil)
            }
        }
    }
}


struct ExtendendIngredientsView2_Previews: PreviewProvider {
    static let sectionItem = SectionItem.example
    static var previews: some View {
        ExtendendIngredientsView2(sectionitem: sectionItem)
    }
}

