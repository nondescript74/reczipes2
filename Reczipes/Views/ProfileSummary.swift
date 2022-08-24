/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that summarizes a profile.
*/

import SwiftUI

struct ProfileSummary: View {
    // MARK: - Properties
    var profile: Profile
    // MARK: - View Process
    var body: some View {
        List {
            Text(profile.username)
                .bold()
                .font(.title)
            
            Text("Notifications: \(self.profile.prefersNotifications ? "On": "Off" )")
            Text("Include Nutrition: \(self.profile.prefersNutritionInclusion ? "On": "Off" )")
            Text("Include Vitamins: \(self.profile.prefersVitaminInclusion ? "On": "Off" )")
            Text("Load New Recipe Set: \(self.profile.loadNewRecipes ? "On": "Off" )")
            
            HStack {
                Image(self.profile.seasonalPhoto.rawValue)
            }
            
            Text("Items Retrieved: \(self.profile.numberOfRecipes.rawValue)")
                        
            VStack(alignment: .leading) {
                Text("Completed Recipes")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        Text("10 Recipes")
                        Text("5 Cooks")
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Recent Recipes ... coming soon")
                    .font(.headline)
            }
        }
    }
}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
    }
}

