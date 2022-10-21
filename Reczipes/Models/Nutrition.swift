//
//  Nutrition.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation

struct Nutrition: Identifiable, Hashable {
    // Nutrition
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let `default` = Self(id: UUID(),
                                minAlcohol: 0,
                                minCalcium: 0,
                                minCarbs: 10,
                                minCalories: 50,
                                minCaffeine: 0,
                                minCholesterol: 0,
                                minCholine: 0,
                                minCopper: 0,
                                minFat: 1,
                                minFiber: 0,
                                minFluoride: 0,
                                minProtein: 10,
                                minSaturatedFat: 0,
                                minSodium: 0,
                                minSugar: 0,
                                maxAlcohol: 100,
                                maxCarbs: 100,
                                maxCaffeine: 100,
                                maxCopper: 100,
                                maxCalcium: 100,
                                maxCholine: 100,
                                maxCholesterol: 100,
                                maxFluoride: 100,
                                maxProtein: 100,
                                maxFat: 100,
                                maxSaturatedFat: 100,
                                maxFiber: 100,
                                maxSodium: 100,
                                maxSugar: 100,
                                maxCalories: 800)



    var id: UUID = UUID()
    var  minAlcohol: Int = 0
    var minCalcium: Int = 0
    var  minCarbs: Int = 10
    var  minCalories: Int = 50
    var  minCaffeine: Int = 0
    var  minCholesterol: Int = 0
    var minCholine: Int = 0
    var minCopper: Int = 0
    var  minFat: Int = 1
    var  minFiber: Int = 0
    var minFluoride: Int = 0
    var  minProtein: Int = 10
    var  minSaturatedFat: Int = 0

    var  minSodium: Int = 0
    var  minSugar: Int = 0

    var  maxAlcohol: Int = 100
    var maxCarbs: Int = 5000
    var  maxCaffeine: Int = 100
    var  maxCopper: Int = 100
    var  maxCalcium: Int = 100
    var  maxCholine: Int = 100
    var  maxCholesterol: Int = 100
    var  maxFluoride: Int = 100
    var  maxProtein: Int = 100
    var  maxFat: Int = 100
    var  maxSaturatedFat: Int = 100
    var  maxFiber: Int = 100
    var  maxSodium: Int = 100
    var  maxSugar: Int = 100
    var  maxCalories: Int = 800

}


