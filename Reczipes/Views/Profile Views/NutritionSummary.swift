//
//  NutritionSummary.swift
//  CRecipes
//
//  Created by Zahirudeen Premji on 6/14/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct NutritionSummary: View {
    // MARK: - Properties
    var profile: Profile
    // MARK: - View Process
    var body: some View {
        VStack {
            Text("Nutrition Settings")
                .bold()
                .font(.title)
            List {
                NutritionRowView(valueName: "Alchohol", minVal: profile.nutrition.minAlcohol, maxVal: profile.nutrition.maxAlcohol)
                NutritionRowView(valueName: "Calories", minVal: profile.nutrition.minCalories, maxVal: profile.nutrition.maxCalories)
                NutritionRowView(valueName: "Calcium", minVal: 0, maxVal: profile.nutrition.maxCalcium)
                NutritionRowView(valueName: "Choline", minVal: 0, maxVal: profile.nutrition.maxCholine)
                NutritionRowView(valueName: "Cholesterol", minVal: profile.nutrition.minCholesterol, maxVal: profile.nutrition.maxCholesterol)
                NutritionRowView(valueName: "Copper", minVal: 0, maxVal: profile.nutrition.maxCopper)
                NutritionRowView(valueName: "Fluoride", minVal: 0, maxVal: profile.nutrition.maxFluoride)
                NutritionRowView(valueName: "Fat", minVal: profile.nutrition.minFat, maxVal: profile.nutrition.maxFat)
                NutritionRowView(valueName: "Fat (Sat.)", minVal: profile.nutrition.minSaturatedFat, maxVal: profile.nutrition.maxSaturatedFat)
                NutritionRowView(valueName: "Fiber", minVal: profile.nutrition.minFiber, maxVal: 100)
            }
        }
    }
}

#if DEBUG
struct NutritionSummary_Previews: PreviewProvider {
    static var previews: some View {
        NutritionSummary(profile: Profile.default)
    }
}
#endif
