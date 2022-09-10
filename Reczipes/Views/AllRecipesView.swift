//
//  AllRecipesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI

struct AllRecipesView: View {
    // MARK: - Debug local
    private var zBug: Bool = true
    // MARK: - Environment Objects
    // MARK: - Properties
    fileprivate enum msgs: String {
        case arv = "All Recipes View"
        case recz = "Reczipes"
        case rshipd = "recipesShipped"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case fuar = "Found user added recipe"
        //        case json = ".json"
    }
//    var isDirectory: ObjCBool = false
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    //    func getBookSections() -> [BookSection] {
    //        var myReturn: [BookSection] = []
    //        let myDocuDirUrl = getDocuDirUrl()
    //        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
    //
    //        do {
    //            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).filter({$0.lastPathComponent.contains(json)})
    //            for aurl in urls {
    //                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrl.absoluteString.appending(aurl.absoluteString))!
    //                let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
    //                myReturn.append(aBookSection)
    //            }
    //            let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})
    //            for aBS in bookSections {
    //                myReturn.append(aBS)
    //            }
    //        } catch  {
    ////            fatalError("Can't read contents of users recipes dir")
    //            // empty or not there?
    //
    //        }
    //
    //        return myReturn
    //    }
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
                        //                        await fileMgr.reload()
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
