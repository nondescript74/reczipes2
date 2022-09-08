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
    var isDirectory: ObjCBool = false
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
    fileprivate func constructAllSections() -> [BookSection] {
        var myReturn: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + json).sorted(by: {$0.name < $1.name})
        myReturn = bookSections
        let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
        let test = FileManager.default.directoryExists(atUrl: myReczipesDirUrl)
        if !test {
            do {
                try FileManager.default.createDirectory(at: myReczipesDirUrl, withIntermediateDirectories: true)
            } catch {
                fatalError("Cannot create directory")
            }
        }
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            for aurl in urls {
                if aurl.pathComponents.contains(msgs.rnotes.rawValue) || aurl.pathComponents.contains(msgs.rimages.rawValue)  {
                    // skip these folders
                } else {
                    let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                    do {
                        let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                        myReturn.append(aBookSection)
                        if zBug { print(msgs.arv.rawValue + msgs.fuar.rawValue)}
                        
                    } catch  {
                        // not a json file
                        fatalError("This directory has illegal files")
                    }
                }
            }
        } catch  {
            // no contents or does not exist
        }
        return myReturn
    }
    
    fileprivate func constructAllRecipes() -> [SectionItem] {
        var myReturn: [SectionItem] = []
        let myBs: [BookSection] = constructAllSections()
        for aBS in myBs {
            for aSI in aBS.items {
                myReturn.append(aSI)
            }
        }
        return myReturn
    }
    
    fileprivate var myBook: [BookSection] {
        var myReturn = constructAllSections()
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

extension FileManager {

    func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}

