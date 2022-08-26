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
    @EnvironmentObject var addedRecipes: AddedRecipes
    
    // MARK: - Properties
    fileprivate enum tabs: String {
        //        case multibook = "Books"
        case books = "Books"
        //        case web = "Search"
        //        case addEdit = "Find/Add"
//        case find = "Find"
//        case ext = "Extract"
        case frextr = "Find/Extract"
        //        case tjc = "Trivia"
        case auth = "Sign In"
        //        case send = "Mail To"
        //        case indian = "Indian"
        //        case random = "Random"
        case ingredients = "Ingred"
        //        case search = "Google"
        //        case viewFolder = "Contents"
        //        case noteAdd = "+Note"
        //        case imageAdd = "+Image"
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
            //            ATestView()
            //                .tabItem{
            //                    Image(uiImage: wandNStarsImage)
            //                    Text(tabs.auth.rawValue)
            //                }
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
            
            //            FindRecipeView()
            //                .tabItem {
            //                    Image(uiImage: imageDocDocFill!)
            //                    Text(tabs.find.rawValue)
            //                }
            //
            //            ExtractRecipeView()
            //                .tabItem {
            //                    Image(uiImage: scribblevariable!)
            //                    Text(tabs.ext.rawValue)
            //                }
            
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
//            
//            MultiView(show: .notyet)
//                .tabItem {
//                    Image(uiImage: crosscirclefill!)
//                    Text(tabs.jt.rawValue)
//                }
            
            SettingsView()
                .tabItem {
                    Image(uiImage: wandNStarsImage)
                    Text(tabs.settings.rawValue)
                }
            
        }
        .environmentObject(order)
        .environmentObject(addedRecipes)
        .environmentObject(userData)
    }
}

//struct ApplicationView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ApplicationView()
//    }
//}
