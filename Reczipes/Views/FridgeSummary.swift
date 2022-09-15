//
//  FridgeSummary.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 9/15/22.
//

import SwiftUI

struct FridgeSummary: View {
    @EnvironmentObject var fridge: MyFridge
    
    var body: some View {
        List {
            
            ForEach(MyFridge.default, id: \.self) { item in
                Text(item)
            }
//            Text(profile.username)
//                .bold()
//                .font(.title)
//
//            Text("Notifications: \(self.profile.prefersNotifications ? "On": "Off" )")
//            Text("Include Nutrition: \(self.profile.prefersNutritionInclusion ? "On": "Off" )")
//            Text("Include Vitamins: \(self.profile.prefersVitaminInclusion ? "On": "Off" )")
//            Text("Load New Recipe Set: \(self.profile.loadNewRecipes ? "On": "Off" )")
//
//            HStack {
//                Image(self.profile.seasonalPhoto.rawValue)
//            }
//
//            Text("Items Retrieved: \(self.profile.numberOfRecipes.rawValue)")
//
//            VStack(alignment: .leading) {
//                Text("Completed Recipes")
//                    .font(.headline)
//                ScrollView(.horizontal) {
//                    HStack {
//                        Text("10 Recipes")
//                        Text("5 Cooks")
//                    }
//                }
//            }
//
//            VStack(alignment: .leading) {
//                Text("Recent Recipes ... coming soon")
//                    .font(.headline)
//            }
        }
    }
}

struct FridgeSummary_Previews: PreviewProvider {
    static var previews: some View {
        FridgeSummary()
    }
}
