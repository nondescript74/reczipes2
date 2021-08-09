//
//  AllRecipesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct AllRecipesView: View {
    // MARK: - Properties
    fileprivate enum msgs: String {
        case arv = "All Recipes View"
        case recipesFile = "recipesShipped.json"
    }
    // MARK: - Methods
    fileprivate var myBook: [BookSection] {
        return Bundle.main.decode([BookSection].self, from: msgs.recipesFile.rawValue).sorted(by: {$0.name < $1.name})
        // recipebook comes from embedded file shipped
        
    }
    var body: some View {
        NavigationView {
            VStack {
                Text(msgs.arv.rawValue).bold()
                    
                List {
                    ForEach(myBook, id: \.self) { section in
                        Section(header: Text(section.name).padding()) {
                            ForEach(section.items) { item in
                                RecipeRowView(sectionItem: item)
                                    .padding()
                            }
                            
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
        }
        //.navigationBarTitle(msgs.arv.rawValue)
        //.navigationBarHidden(false)
    }
    
}

#if DEBUG
struct AllRecipesView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let addedRecipes = AddedRecipes()
    static var previews: some View {
        Group {
            AllRecipesView()
                .environmentObject(order)
                .environmentObject(addedRecipes)
                .colorScheme(.dark)
        }
    }
}
#endif
