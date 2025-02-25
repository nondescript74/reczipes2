//
//  NutritionSummary.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 6/14/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct NutritionSummary: View {
    // MARK: - Properties
    var profile: Profile
    fileprivate enum msgs: String {
        case title = "Nutrition Settings"
    }
    fileprivate enum nutrients: String {
        case alc = "Alcohol"
        case calo = "Calories"
        case calc = "Calcium"
        case chol = "Choline"
        case colo = "Cholesterol"
        case copp = "Copper"
        case fluo = "Fluoride"
        case fat = "Fat"
        case fatsat = "Fat, Saturated"
        case fibr = "Fiber"

    }
    // MARK: - View Process
    var body: some View {
        VStack {
            Text(msgs.title.rawValue)
                .bold()
                .font(.title)
            List {
//                NutritionRowView(valueName: nutrients.alc.rawValue, minVal: profile.nutrition.minAlcohol, maxVal: profile.nutrition.maxAlcohol)
//                NutritionRowView(valueName: nutrients.calo.rawValue, minVal: profile.nutrition.minCalories, maxVal: profile.nutrition.maxCalories)
//                NutritionRowView(valueName: nutrients.calc.rawValue, minVal: 0, maxVal: profile.nutrition.maxCalcium)
//                NutritionRowView(valueName: nutrients.chol.rawValue, minVal: 0, maxVal: profile.nutrition.maxCholine)
//                NutritionRowView(valueName: nutrients.colo.rawValue, minVal: profile.nutrition.minCholesterol, maxVal: profile.nutrition.maxCholesterol)
//                NutritionRowView(valueName: nutrients.copp.rawValue, minVal: 0, maxVal: profile.nutrition.maxCopper)
//                NutritionRowView(valueName: nutrients.fluo.rawValue, minVal: 0, maxVal: profile.nutrition.maxFluoride)
//                NutritionRowView(valueName: nutrients.fat.rawValue, minVal: profile.nutrition.minFat, maxVal: profile.nutrition.maxFat)
//                NutritionRowView(valueName: nutrients.fatsat.rawValue, minVal: profile.nutrition.minSaturatedFat, maxVal: profile.nutrition.maxSaturatedFat)
//                NutritionRowView(valueName: nutrients.fibr.rawValue, minVal: profile.nutrition.minFiber, maxVal: profile.nutrition.maxFiber)
            }
        }
    }
}


struct NutritionSummary_Previews: PreviewProvider {
    static var previews: some View {
        NutritionSummary(profile: Profile.default)
    }
}

