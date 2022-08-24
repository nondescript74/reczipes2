//
//  AllRecipesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct AllRecipesView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - Properties
    fileprivate enum msgs: String {
        case arv = "All Recipes View"
    }
    // MARK: - Methods
    fileprivate var myBook: [BookSection] {
        let addedSections = addedRecipes.bookSections.sorted(by: {$0.name < $1.name})  // anything in added Recipes
        return addedSections
    }
    var body: some View {
        NavigationView {
            VStack {
                Text(msgs.arv.rawValue).font(.largeTitle).bold()
                
                List {
                    ForEach(myBook, id: \.self) { section in
                        Section(header: Text(section.name).padding()) {
                            ForEach(section.items) { item in
                                RecipeRowView(sectionItem: item, cuisine: section.name)
                                    .padding()
                            }
                            
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
        }
    }
    
}


struct AllRecipesView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let addedRecipes = AddedRecipes()
    static var previews: some View {
        Group {
            AllRecipesView()
                .environmentObject(order)
                .environmentObject(addedRecipes)
                .colorScheme(.light)
        }
    }
}

