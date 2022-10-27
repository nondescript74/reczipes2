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
    @EnvironmentObject var fridge: MyFridge
    @EnvironmentObject var ratio: RecipeRatio
    @EnvironmentObject var recipeIngreds: RecipeIngredients
    @EnvironmentObject var recipeInstr: RecipeInstructions
    @EnvironmentObject var recipeImgs: RecipeImages
    
    // MARK: - Properties
    fileprivate enum tabs: String {
        case books = "Books"
        case frextr = "Find/Extract"
        case auth = "Sign In"
        case ingredients = "Ingred"
        case multiAdd = "+Note/Image"
        case jt = "Joke/Trivia"
        case settings = "Settings"
        case build = "Build"
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
            
            SettingsView()
                .tabItem {
                    Image(uiImage: wandNStarsImage)
                    Text(tabs.settings.rawValue)
                }
            
            BuildRecipeView()
                .tabItem {
                    Image(uiImage: tortoise!)
                    Text(tabs.build.rawValue)
                }
            
        }
        .environmentObject(order)
        .environmentObject(userData)
        .environmentObject(fridge)
        .environmentObject(ratio)
        .environmentObject(recipeIngreds)
        .environmentObject(recipeInstr)
        .environmentObject(recipeImgs)
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let userData = UserData()
    static let myfridge = MyFridge()
    static let rratio = RecipeRatio()
    static let recipIngreds = RecipeIngredients()
    static let recipInstr = RecipeInstructions()
    static let recipImgs = RecipeImages()
    
    static var previews: some View {
        ApplicationView()
            .environmentObject(order)
            .environmentObject(userData)
            .environmentObject(myfridge)
            .environmentObject(rratio)
            .environmentObject(recipIngreds)
            .environmentObject(recipInstr)
            .environmentObject(recipImgs)
    }
}
