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
    private func getReczDirContents(lpc:Bool) -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue), includingPropertiesForKeys: [])
            if lpc {
                myReturn = contUrls.map({$0.lastPathComponent})
            } else {
                myReturn = contUrls.map({$0.absoluteString})
            }
        } catch  {
            
        }
        return myReturn
    }
    
    fileprivate func constructAllRecipes() -> [SectionItem] {
        var myReturn: [SectionItem] = []
        let myBs: [BookSection] = FileManager.default.constructAllSections()
        for aBS in myBs {
            for aSI in aBS.items {
                myReturn.append(aSI)
            }
        }
        return myReturn
    }
    
    fileprivate var myBook: [BookSection] {
        var myReturn = FileManager.default.constructAllSections()
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
                    }
            }
        }
    }
}


struct AllRecipesView_Previews: PreviewProvider {
    static let order = OrderingList()
    
    static var previews: some View {
        Group {
            AllRecipesView()
                .environmentObject(order)
                .colorScheme(.light)
        }
    }
}
