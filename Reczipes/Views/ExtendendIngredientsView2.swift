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
    init(sectionitem: SectionItem, ratio: Double) {  //
        extractedSRecipe.findExtracted(urlString: sectionitem.url)
        self.ratio = ratio
    }
    // MARK: - Properties
    fileprivate var ratio: Double = 1.0
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(extractedSRecipe.extractedSRecipe?.extendedIngredients ?? [ExtendedIngredient.extendedIngredientExample], id: \.self) { extIng in
                    ExtendedIngredView(extendedIngredient: extIng!, ratio: self.ratio)
                }.disabled(extractedSRecipe.extractedSRecipe?.extendedIngredients == nil)
                    .padding([.top, .bottom])
            }
        }
    }
}


struct ExtendendIngredientsView2_Previews: PreviewProvider {
    static let sectionItem = SectionItem.example
    static var previews: some View {
        ExtendendIngredientsView2(sectionitem: sectionItem, ratio: 1.0)
    }
}

