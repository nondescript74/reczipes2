//
//  Nutrition.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation

struct Nutrition: Identifiable, Hashable {
    // Nutrition
    
    static let `default` = Self(id: UUID(),
                                minAlcohol: 0,
                                minCarbs: 10,
                                minProtein: 10,
                                minCalories: 50,
                                maxCarbs: 100,
                                minCaffeine: 0,
                                minCholesterol: 0,
                                minSaturatedFat: 0,
                                minFiber: 0,
                                minSodium: 0,
                                minSugar: 0,
                                minFat: 1,
                                maxAlcohol: 100,
                                maxCaffeine: 100,
                                maxCopper: 100,
                                maxCalcium: 100,
                                maxCholine: 100,
                                maxCholesterol: 100,
                                maxFluoride: 100,
                                maxProtein: 100,
                                maxFat: 100,
                                maxSaturatedFat: 100,
                                maxSodium: 100,
                                maxSugar: 100,
                                maxCalories: 800)
    
    var id: UUID = UUID()
    var  minAlcohol: Int = 0
    var  minCarbs: Int = 10
    var  minProtein: Int = 10
    var  minCalories: Int = 50
    var  maxCarbs: Int = 100
    var  minCaffeine: Int = 0
    var  minCholesterol: Int = 0
    var  minSaturatedFat: Int = 0
    var  minFiber: Int = 0
    var  minSodium: Int = 0
    var  minSugar: Int = 0
    var  minFat: Int = 1
    var  maxAlcohol: Int = 100
    var  maxCaffeine: Int = 100
    var  maxCopper: Int = 100
    var  maxCalcium: Int = 100
    var  maxCholine: Int = 100
    var  maxCholesterol: Int = 100
    var  maxFluoride: Int = 100
    var  maxProtein: Int = 100
    var  maxFat: Int = 100
    var  maxSaturatedFat: Int = 100
    var  maxSodium: Int = 100
    var  maxSugar: Int = 100
    var  maxCalories: Int = 800
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(maxAlcohol)
        hasher.combine(maxCalories)
        hasher.combine(maxCarbs)
        hasher.combine(maxSaturatedFat)
        hasher.combine(maxSodium)
    }
}

/*
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
 */


