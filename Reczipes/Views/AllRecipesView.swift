//
//  AllRecipesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct AllRecipesView: View {
    // MARK: - Debug local
    private var zBug:Bool = false
    // MARK: - Environment Objects
    @EnvironmentObject var auu: AllUserRecipes
    // MARK: - Properties
    fileprivate enum msgs: String {
        case arv = "All Recipes View"
        case recz = "Reczipes"
        case rshipd = "recipesShipped"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case fuar = "Found user added recipe"

    }
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    
    fileprivate var myBook: [BookSection] {
        return auu.sections
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
                    .refreshable {
                    }
            }
        }
    }
}


struct AllRecipesView_Previews: PreviewProvider {
//    static let order = OrderingList()
    
    static var previews: some View {
        Group {
            AllRecipesView()
                .environmentObject(AllUserRecipes())
                .colorScheme(.light)
        }
    }
}
