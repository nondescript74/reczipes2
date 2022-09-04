//
//  AllRecipesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct AllRecipesView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var fileMgr: FileMgr
    // MARK: - Properties
    fileprivate enum msgs: String {
        case arv = "All Recipes View"
    }
    // MARK: - Methods
    fileprivate var myBook: [BookSection] {
        var myReturn: [BookSection] = []
        let shipped = fileMgr.shippedBookSectionsDirContents
        let user = fileMgr.userBookSectionsDirContents
        for abs in shipped {
            if (user.filter({$0.id == abs.id}).first != nil) {
                let userItems: [SectionItem] = (user.filter({$0.id == abs.id}).first!.items)
                var combinedItems: [SectionItem] = userItems
                combinedItems.append(contentsOf: abs.items)
                let bsCombinedItems = BookSection(id: abs.id, name: abs.name, items: combinedItems)
                myReturn.append(bsCombinedItems)
            } else {
                myReturn.append(abs)
            }
        }
        myReturn = myReturn.sorted(by: {$0.name < $1.name})
        return myReturn
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
//                        await fileMgr.reload()
                    }
            }
        }
    }
    
}


struct AllRecipesView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let fileMgr = FileMgr()
    //    static let addedRecipes = AddedRecipes()
    static var previews: some View {
        Group {
            AllRecipesView()
                .environmentObject(order)
                .environmentObject(fileMgr)
                .colorScheme(.light)
        }
    }
}

