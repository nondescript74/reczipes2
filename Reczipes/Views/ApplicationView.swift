//
//  ApplicationView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct ApplicationView: View {
    
    // MARK: - Environment Variables
    @EnvironmentObject var order: OrderingList
    
    // MARK: - Properties
    fileprivate enum tabs: String {
        case multibook = "Books"
        case web = "Search"
        case addEdit = "Add/Edit"
        case tjc = "Trivia"
        case auth = "Sign In"
        case indian = "Indian"
        case random = "Random"
        case ingredients = "Ingred"
        case search = "Google"
        case viewFolder = "Contents"
        case noteAdd = "+Note"
        case imageAdd = "+Image"
        case multiAdd = "+Note/Image"
    }
    
    var body: some View {
        TabView {
            
            AllRecipesView()
                .tabItem {
                    Image(uiImage: imageDocDocEmpty!)
                    Text(tabs.multibook.rawValue)
                }
            
            AddRecipeView4()
                .tabItem {
                    Image(uiImage: imageDocDocFill!)
                    Text(tabs.addEdit.rawValue)
                }
            
            
            
        }
        .environmentObject(order)
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView()
    }
}
