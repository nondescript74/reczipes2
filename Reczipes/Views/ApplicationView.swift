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
    
    // MARK: - Properties
    fileprivate enum tabs: String {
        case books = "Books"
        case frextr = "Find/Extract"
        case auth = "Sign In"
        case ingredients = "Ingred"
        case multiAdd = "+Note/Image"
        case jt = "Joke/Trivia"
        case settings = "Settings"
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
            
            MultiView(show: .notyet)
                .tabItem {
                    Image(uiImage: tortoise!)
                    Text(tabs.jt.rawValue)
                }
                
            
        }
        .environmentObject(order)
        .environmentObject(userData)
        .environmentObject(fridge)
        .environmentObject(ratio)
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let userData = UserData()
    static let myfridge = MyFridge()
    static let rratio = RecipeRatio()
    
    static var previews: some View {
        ApplicationView()
            .environmentObject(order)
            .environmentObject(userData)
            .environmentObject(myfridge)
            .environmentObject(rratio)
    }
}
