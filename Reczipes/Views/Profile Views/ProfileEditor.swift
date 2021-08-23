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
    // MARK: - Properties
    private enum msgs: String {
        case uname: "Username"
        case enablNotif: "Enable Notifications"
        case enablNutr: "Enable Nutrition"
        case enablVitInSearch: "Enable Vitamin set in search"
        case loadNewRecip: "Load New Recipe Set next launch"
        case seasPhoto: "Seasonal Photo"
        case numbrRetr: "Number retrieved"
        case countz: "Count"
    }
    // MARK: - View Process
    var body: some View {
        List {
            HStack {
                Text(msgs.uname.rawValue).bold()
                Divider()
                TextField(msgs.uname.rawValue, text: $profile.username)
            }
            
            Toggle(isOn: $profile.prefersNotifications) {
                Text(msgs.enablNotif.rawValue)
            }.disabled(self.prefersNotification == false)
            
            Toggle(isOn: $profile.prefersNutritionInclusion) {
                Text(msgs.enablNutr.rawValue)
            }.disabled(self.showingNutrition == false)
            
            Toggle(isOn: $profile.prefersVitaminInclusion) {
                Text(msgs.enablVitInSearch.rawValue)
            }.disabled(self.showingVitamins == false)
            
            Toggle(isOn: $profile.loadNewRecipes) {
                Text(msgs.loadNewRecip.rawValue)
            }.disabled(self.loadNewRecipes == false)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(msgs.seasPhoto.rawValue).bold()
                
                Picker(msgs.seasPhoto.rawValue, selection: $profile.seasonalPhoto) {
                    ForEach(Profile.Season.allCases, id: \.self) { season in
                        Image(season.rawValue).tag(season).frame(minHeight: 150)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .scaleEffect(x: 1, y: 2, anchor: .topLeading)
                
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text(msgs.numbrRetr.rawValue).bold()
                
                Picker(msgs.countz.rawValue, selection: $profile.numberOfRecipes) {
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
