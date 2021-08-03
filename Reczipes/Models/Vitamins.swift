//
//  Vitamins.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation

struct Vitamins: Identifiable, Hashable {
    // Vitamins view model for the Nutrition view model
    
    static let `default` = Self(id: UUID(),
                                minCopper: 0,
                                minCalcium: 0,
                                minCholine: 0,
                                minFluoride: 0,
                                minVitaminA: 0,
                                minVitaminC: 0,
                                minVitaminD: 0,
                                minVitaminE: 0,
                                minVitaminK: 0,
                                minVitaminB1: 0,
                                minVitaminB2: 0,
                                minVitaminB5: 0,
                                minVitaminB3: 0,
                                minVitaminB6: 0,
                                minVitaminB12: 0,
                                minFolate: 0,
                                minFolicAcid: 0,
                                minIodine: 0,
                                minIron: 0,
                                minMagnesium: 0,
                                minManganese: 0,
                                minPhosphorus: 0,
                                minPotassium: 0,
                                minSelenium: 0,
                                minZinc: 0,
                                maxCopper: 100,
                                maxCalcium: 100,
                                maxCholine: 100,
                                maxFluoride: 100,
                                maxVitaminA: 100,
                                maxVitaminC: 100,
                                maxVitaminD: 100,
                                maxVitaminE: 100,
                                maxVitaminK: 100,
                                maxVitaminB1: 100,
                                maxVitaminB2: 100,
                                maxVitaminB5: 100,
                                maxVitaminB3: 100,
                                maxVitaminB6: 100,
                                maxVitaminB12: 100,
                                maxFolate: 100,
                                maxFolicAcid: 100,
                                maxIodine: 100,
                                maxIron: 100,
                                maxMagnesium: 100,
                                maxManganese: 100,
                                maxPhosphorus: 100,
                                maxPotassium: 100,
                                maxSelenium: 100,
                                maxZinc: 100
    )
    
    var id: UUID = UUID()
    var  minCopper: Int = 0
    var  minCalcium: Int = 0
    var  minCholine: Int = 0
    var  minFluoride: Int = 0
    var  minVitaminA: Int = 0
    var  minVitaminC: Int = 0
    var  minVitaminD: Int = 0
    var  minVitaminE: Int = 0
    var  minVitaminK: Int = 0
    var  minVitaminB1: Int = 0
    var  minVitaminB2: Int = 0
    var  minVitaminB5: Int = 0
    var  minVitaminB3: Int = 0
    var  minVitaminB6: Int = 0
    var  minVitaminB12: Int = 0
    var  minFolate: Int = 0
    var  minFolicAcid: Int = 0
    var  minIodine: Int = 0
    var  minIron: Int = 0
    var  minMagnesium: Int = 0
    var  minManganese: Int = 0
    var  minPhosphorus: Int = 0
    var  minPotassium: Int = 0
    var  minSelenium: Int = 0
    var  minZinc: Int = 0
    var  maxCopper: Int = 100
    var  maxCalcium: Int = 100
    var  maxCholine: Int = 100
    var  maxFluoride: Int = 100
    var  maxVitaminA: Int = 100
    var  maxVitaminC: Int = 100
    var  maxVitaminD: Int = 100
    var  maxVitaminE: Int = 100
    var  maxVitaminK: Int = 100
    var  maxVitaminB1: Int = 100
    var  maxVitaminB2: Int = 100
    var  maxVitaminB5: Int = 100
    var  maxVitaminB3: Int = 100
    var  maxVitaminB6: Int = 100
    var  maxVitaminB12: Int = 100
    var  maxFolate: Int = 100
    var  maxFolicAcid: Int = 100
    var  maxIodine: Int = 100
    var  maxIron: Int = 100
    var  maxMagnesium: Int = 100
    var  maxManganese: Int = 100
    var  maxPhosphorus: Int = 100
    var  maxPotassium: Int = 100
    var  maxSelenium: Int = 100
    var  maxZinc: Int = 100
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(maxZinc)
        hasher.combine(minPotassium)
        hasher.combine(minIron)
        hasher.combine(minMagnesium)
        
    }
}
