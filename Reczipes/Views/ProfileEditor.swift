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
//    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userData: UserData
    // MARK: - State
    @State fileprivate var showingNutrition = false
    @State fileprivate var showingVitamins = false
    @State fileprivate var prefersNotification = false
    @State fileprivate var loadNewRecipes = false
    @State fileprivate var apiKey = ""
    @State fileprivate var keyAvailable: Bool = false
    // MARK: - Properties
    private enum msgs: String {
        case profE = "Profile Editor: "
        case uname = "Username"
        case enablNotif = "Enable Notifications"
        case enablNutr = "Enable Nutrition"
        case enablVitInSearch = "Enable Vitamin set in search"
        case loadNewRecip = "Load New Recipe Set next launch"
        case seasPhoto = "Seasonal Photo"
        case numbrRetr = "Number retrieved"
        case countz = "Count"
        case key = "Please enter your api key"
    }
    
    fileprivate enum labelz: String {
        case top = "Enter"
        case bot = "ApiKey"
    }
    
    fileprivate enum imagez: String {
        case prof = "greetingcard"
    }
    // MARK: - Methods
    // MARK: - View Process
    var body: some View {
        List {
            HStack {
                Text(msgs.uname.rawValue).bold()
                Divider()
                TextField(msgs.uname.rawValue, text: $profile.username)
            }.padding(.bottom)
            HStack {
                
                Button(action: {
                    // What to perform
                    keyAvailable.toggle()
                    
                }) {
                    // How the button looks like
                    RoundButton3View(someTextTop: labelz.top.rawValue, someTextBottom: labelz.bot.rawValue, someImage: imagez.prof.rawValue, reversed: false)
                }.disabled(apiKey == "").padding(.bottom)
                
                TextField(msgs.key.rawValue, text: $apiKey)
            }
            
            Toggle(isOn: $profile.prefersNotifications) {
                Text(msgs.enablNotif.rawValue)
            }
            
            Toggle(isOn: $profile.prefersNutritionInclusion) {
                Text(msgs.enablNutr.rawValue)
            }
            
            Toggle(isOn: $profile.prefersVitaminInclusion) {
                Text(msgs.enablVitInSearch.rawValue)
            }
            
            Toggle(isOn: $profile.loadNewRecipes) {
                Text(msgs.loadNewRecip.rawValue)
            } 
            
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
        }.sheet(isPresented: $keyAvailable) {
            KeyView(apikey: apiKey)
        }
    }
}


struct ProfileEditor_Previews: PreviewProvider {
    @Binding var keyValue: String
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

