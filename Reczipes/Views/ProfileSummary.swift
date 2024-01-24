/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that summarizes a profile.
*/

import SwiftUI

struct ProfileSummary: View {
    // MARK: - Environment
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var aui: AllUserImages
    // MARK: - Properties
    var profile: Profile
    // MARK: - Methods
    fileprivate func getRecips() -> [SectionItem2] {
        let myReturn = aur.sections.flatMap({$0.items})
        return myReturn
    }
    fileprivate func getNotes() -> [Note] {
        let myReturn = aun.notes
        return myReturn
    }
    fileprivate func getImages() -> [ImageSaved] {
        let myReturn = aui.images
        return myReturn
    }
    // MARK: - View Process
    var body: some View {
        List {
            Text(profile.username)
                .bold()
                .font(.title)
            
            Text("Notifications: \(self.profile.prefersNotifications ? "On": "Off" )")
            Text("Include Nutrition: \(self.profile.prefersNutritionInclusion ? "On": "Off" )")
            Text("Include Vitamins: \(self.profile.prefersVitaminInclusion ? "On": "Off" )")
            
            HStack {
                Image(self.profile.seasonalPhoto.rawValue)
            }
            
            Text("Items being retrieved: \(self.profile.numberOfRecipes.rawValue)")
                        
            VStack(alignment: .leading) {
                Text("Number of saved recipes: \(getRecips().count)")
                    
                Text("Number of saved images: \(getImages().count)")
                    
                Text("Number of saved notes: \(getNotes().count)")
                    

            }
        }
    }
}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
            .environmentObject(AllUserRecipes())
            .environmentObject(AllUserNotes())
            .environmentObject(AllUserImages())
    }
}

