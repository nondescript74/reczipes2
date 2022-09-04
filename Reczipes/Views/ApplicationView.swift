//
//  ApplicationView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct ApplicationView: View {
    
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
//    @EnvironmentObject var addedRecipes: AddedRecipes
    @EnvironmentObject var fileMgr: FileMgr
    
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
    private func getAppVersionAndBuild() {
        return
    }
    
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
            
        }
        .environmentObject(order)
        .environmentObject(fileMgr)
        .environmentObject(userData)
    }
}

struct ApplicationView_Previews: PreviewProvider {

    static var previews: some View {
        ApplicationView()
    }
}
