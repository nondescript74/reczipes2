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
    @EnvironmentObject var rbb: RecipeBeingBuilt
    @EnvironmentObject var auu: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var aui: AllUserImages

    
    // MARK: - Properties
    fileprivate enum tabs: String {
        case books = "Books"
        case uf = "User Files"
        case frextr = "Find/Extract"
        case auth = "Sign In"
        case ingredients = "Ingred"
        case multiAdd = "+Note/Image"
        case jt = "Joke/Trivia"
        case settings = "Settings"
        case build = "Build"
        case enterKey = "ApiKey"
        case fi = "find 🍒"
    }
    
    
    // MARK: - Methods
    
    var body: some View {
        TabView {
            AllRecipesView()
                .tabItem {
                    Image(uiImage: imageDocDocEmpty!)
                    Text(tabs.books.rawValue)
                }
            FindOrExtractView()
                .tabItem {
                    Image(uiImage: scribblevariable!)
                    Text(tabs.frextr.rawValue)
                }
            
            AddImageAndNoteView()
                .tabItem {
                    Image(uiImage: scribblevariable!)
                    Text(tabs.multiAdd.rawValue)
                }
            
            OrderIngredientsView()
                .tabItem {
                    Image(uiImage: squareandarrowdown!)
                    Text(tabs.ingredients.rawValue)
                }
            
            AuthView()
                .tabItem {
                    Image(uiImage: wandNStarsImage)
                    Text(tabs.auth.rawValue)
                }
            
            KeyView(apikey: UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")
                .tabItem {
                    Image(uiImage: imageSquarePencil!)
                    Text(tabs.enterKey.rawValue)
                }
            
            SettingsView()
                .tabItem {
                    Image(uiImage: imageDocDocEmpty!)
                    Text(tabs.settings.rawValue)
                }
            
//            CreateSRecipeFieldsView()
//                .tabItem {
//                    Image(uiImage: tortoise!)
//                    Text(tabs.build.rawValue)
//                }
            
            FilesDisplayView()
                .tabItem {
                    Image(uiImage: hare!)
                    Text(tabs.uf.rawValue)
                }
            
            MultiView(show: .notyet)
                .tabItem {
                    Image(uiImage: suitImage)
                    Text(tabs.jt.rawValue)
                }
            
            
        }
        .environmentObject(order)
        .environmentObject(userData)
        .environmentObject(ratio)
        .environmentObject(rbb)
        .environmentObject(aun)
        .environmentObject(aui)
        .environmentObject(auu)
        
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let userData = UserData()
    static let rratio = RecipeRatio()
    static let rbb = RecipeBeingBuilt()
    static let aur = AllUserRecipes()
    static let aun = AllUserNotes()
    static let aui = AllUserImages()
    
    static var previews: some View {
        ApplicationView()
            .environmentObject(order)
            .environmentObject(userData)
            .environmentObject(rratio)
            .environmentObject(rbb)
            .environmentObject(aur)
            .environmentObject(aun)
            .environmentObject(aui)
    }
}
