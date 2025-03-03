/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that summarizes a profile.
*/

import SwiftUI

struct ProfileSummary: View {
    // MARK: - Environment
    @Environment(AllUserRecipes.self) private var aur
    @Environment(AllUserNotes.self) private var aun
    @Environment(AllUserImages.self) private var aui
    // MARK: - Properties
    var profile: Profile
    // MARK: - Methods
    fileprivate func getRecipes() -> [SectionItem3] {
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
                Text("Number of saved recipes: \(getRecipes().count)")
                    
                Text("Number of saved images: \(getImages().count)")
                    
                Text("Number of saved notes: \(getNotes().count)")
                    

            }
        }
        .environment(aur)
        .environment(aun)
        .environment(aui)
    }
}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
            .environment(AllUserRecipes())
            .environment(AllUserNotes())
            .environment(AllUserImages())
    }
}

