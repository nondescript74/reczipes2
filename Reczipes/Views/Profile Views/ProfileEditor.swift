/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 An editable profile view.
 */

import SwiftUI

struct ProfileEditor: View {
    
    // MARK: - Binding
    @Binding var profile: Profile
    // MARK: - Environment Variables
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userData: UserData
    // MARK: - State
    @State fileprivate var showingNutrition = false
    @State fileprivate var showingVitamins = false
    @State fileprivate var prefersNotification = false
    @State fileprivate var loadNewRecipes = false
    // MARK: - View Process
    var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)
            }
            
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications")
            }.disabled(self.prefersNotification == false)
            
            Toggle(isOn: $profile.prefersNutritionInclusion) {
                Text("Enable Nutrition in search")
            }.disabled(self.showingNutrition == false)
            
            Toggle(isOn: $profile.prefersVitaminInclusion) {
                Text("Enable Vitamin set in search")
            }.disabled(self.showingVitamins == false)
            
            Toggle(isOn: $profile.loadNewRecipes) {
                Text("Load New Recipe Set next launch")
            }.disabled(self.loadNewRecipes == false)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Seasonal Photo").bold()
                
                Picker("Seasonal Photo", selection: $profile.seasonalPhoto) {
                    ForEach(Profile.Season.allCases, id: \.self) { season in
                        Image(season.rawValue).tag(season).frame(minHeight: 150)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .scaleEffect(x: 1, y: 2, anchor: .topLeading)
                
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Number retrieved").bold()
                
                Picker("Count", selection: $profile.numberOfRecipes) {
                    ForEach(Profile.NumberZ.allCases, id: \.self) { numberx in
                        Text(numberx.rawValue.description).tag(numberx)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            .padding(.top)
            
        }
    }
}

#if DEBUG
struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileEditor(profile: .constant(.default))
                .previewDevice("iPhone Xr")
            ProfileEditor(profile: .constant(.default))
                .environment(\.colorScheme, .dark)
                .previewDevice("iPhone Xr")
        }
    }
}
#endif
