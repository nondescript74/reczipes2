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
    //    @EnvironmentObject var fileMgr: FileMgr
    // MARK: - Properties
    fileprivate enum msgs: String {
        case arv = "All Recipes View"
        case recz = "Reczipes"
        case rshipd = "recipesShipped"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case json = ".json"
    }
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    private func getDocuDirUrl() -> URL {
        var myReturn:URL
        do {
            let myDocuDirUrl = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            myReturn = myDocuDirUrl
        } catch {
            fatalError()
        }
        return myReturn
    }
    func getBookSections() -> [BookSection] {
        var myReturn: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).filter({$0.lastPathComponent.contains(msgs.json.rawValue)})
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrl.absoluteString.appending(aurl.absoluteString))!
                let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                myReturn.append(aBookSection)
            }
            let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})
            for aBS in bookSections {
                myReturn.append(aBS)
            }
        } catch  {
            fatalError("Can't read contents of users recipes dir")
        }
        
        return myReturn
    }
    fileprivate var myBook: [BookSection] {
        var myReturn = getBookSections()
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

