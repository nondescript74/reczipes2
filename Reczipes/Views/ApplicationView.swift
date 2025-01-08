//
//  ApplicationView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI
import AuthenticationServices

struct ApplicationView: View {
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var ratio: RecipeRatio
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var aui: AllUserImages
    @EnvironmentObject var myAI: AnalyzedInstructionsModel
    @EnvironmentObject var mySRecipeWithInfo: SRecipeWithInfo
    // MARK: - Properties
    fileprivate enum tabs: String {
        case books = "Books"
        case uf = "User Files"
        case frextr = "Find/Extract"
        case auth = "Sign In"
        case ingredients = "Ingred"
        case multiAdd = "+Note/Image"
        case note = "+Note"
        case img = "+Image"
        case jt = "Joke/Trivia"
        case prof = "Profile"
        case settings = "Settings"
        case build = "Build"
        case enterKey = "ApiKey"
        case fi = "find 🍒"
    }
    var body: some View {
        TabView {
            AllRecipesView(aur: aur)
                .tabItem {
                    Image(uiImage: imageDocDocEmpty!)
                    Text(tabs.books.rawValue)
                }
            
            FindOrExtractView()
                .tabItem {
                    Image(uiImage: scribblevariable!)
                    Text(tabs.frextr.rawValue)
                }
            
            AddImageView()
                .tabItem {
                    Image(uiImage: magnifyingglass!)
                    Text(tabs.img.rawValue)
                }
            
            AddNoteView()
                .tabItem {
                    Image(uiImage: suitImage)
                    Text(tabs.note.rawValue)
                }
        
            OrderIngredientsView2()
                .tabItem {
                    Image(uiImage: squareandarrowdown!)
                    Text(tabs.ingredients.rawValue)
                }
            
            KeyView()
                .tabItem {
                    Image(uiImage: imageSquarePencil!)
                    Text(tabs.enterKey.rawValue)
                }
            
            SettingsView()
                .tabItem {
                    Image(uiImage: imageDocDocEmpty!)
                    Text(tabs.settings.rawValue)
                }
            
            FilesDisplayView2()
                .tabItem {
                    Image(uiImage: hare!)
                    Text(tabs.uf.rawValue)
                }
            
            MultiView(show: .notyet)
                .tabItem {
                    Image(uiImage: suitImage)
                    Text(tabs.jt.rawValue)
                }
            
            ProfileEditor(profile: $userData.profile)
                .tabItem {
                    Image(uiImage: checkmarkImage)
                    Text(tabs.prof.rawValue)
                }
        }
        .environmentObject(order)
        .environmentObject(userData)
        .environmentObject(ratio)
        .environmentObject(aun)
        .environmentObject(aui)
        .environmentObject(aur)
        .environmentObject(myAI)
        .environmentObject(mySRecipeWithInfo)
        
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let userData = UserData()
    static let rratio = RecipeRatio()
    static let aur = AllUserRecipes()
    static let aun = AllUserNotes()
    static let aui = AllUserImages()
    static let myAi = AnalyzedInstructionsModel()
    static let mysrwi = SRecipeWithInfo()
    
    static var previews: some View {
        ApplicationView()
            .environmentObject(order)
            .environmentObject(userData)
            .environmentObject(rratio)
            .environmentObject(aur)
            .environmentObject(aun)
            .environmentObject(aui)
            .environmentObject((myAi))
            .environmentObject(mysrwi)
    }
}
