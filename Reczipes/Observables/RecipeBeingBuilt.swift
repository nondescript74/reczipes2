//
//  RecipeBeingBuilt.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/9/22.
//

import Foundation

class RecipeBeingBuilt: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Initializer
    init() {
        self.srecipe = mySRecipeToBe
    }
    // MARK: - Publisher
    @Published var srecipe: SRecipe?
    // MARK: - Properties
    fileprivate var mySRecipeToBe: SRecipe = SRecipe(aggregateLikes: 0,
                                                     analyzedInstructions: [AnalyzedInstructions.aInstructionsExample],
                                                     cheap: false,
                                                     cookingMinutes: 0,
                                                     creditsText: "Z. Premji",
                                                     cuisines: ["Indian"],
                                                     dairyFree: false,
                                                     diets: [],
                                                     dishTypes: [],
                                                     extendedIngredients: [],
                                                     gaps: "",
                                                     glutenFree: false,
                                                     healthScore: 0.0,
                                                     id: Int64.random(in: 1..<myMax),
                                                     image: "",
                                                     imageType: "",
                                                     instructions: "First",
                                                     license: "Z",
                                                     lowFodmap: false,
                                                     occasions: [],
                                                     originalId: "",
                                                     preparationMinutes: 0,
                                                     pricePerServing: 0.0,
                                                     readyInMinutes: 0,
                                                     servings: 0,
                                                     sourceName: "Z",
                                                     spoonacularScore: 0.0,
                                                     spoonacularSourceUrl: "",
                                                     summary: "This is a good recipe",
                                                     sustainable: false,
                                                     title: "",
                                                     vegan: false,
                                                     vegetarian: false,
                                                     veryHealthy: false,
                                                     veryPopular: false,
                                                     weightWatcherSmartPoints: 0,
                                                     winePairing: WinePairing()
    )
}
