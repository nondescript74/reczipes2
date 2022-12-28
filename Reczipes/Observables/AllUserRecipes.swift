//
//  AllUserRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/26/22.
//

import Foundation

class AllUserRecipes: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Publisher
    @Published var sections = [BookSection]()
    // MARK: - Initializer
    init() {
        self.sections = FileManager.default.constructAllSections()
#if DEBUG
        print(msgs.aur.rawValue + "initialized")
        //        print(msgs.aur.rawValue + sections.debugDescription)
#endif
    }
    //MARK: - Properties
    fileprivate enum msgs: String {
        case aur = "AllUserRecipes: "
        case added = "Added: "
        case removed = "Removed: "
        case chgAdd = "Changed, added recipe: "
        case chgRem = "Changed, removed recipe: "
        case chgNew = "Could not find booksection, adding"
        case notchg = "Did not change section "
        case total = "Total: "
        case failedtw = "Failed to write booksection to files"
    }
    
    var total: Int {
#if DEBUG
        print(msgs.aur.rawValue + msgs.total.rawValue, sections.count)
#endif
        return sections.count
    }
    // MARK: - Methods
    func getBookSectionsIDNames() -> [BookSectionIDName] {
        let bsin:[BookSectionIDName] = Bundle.main.decode([BookSectionIDName].self, from: "SectionNames.json").sorted(by: {$0.name < $1.name})
        return bsin
    }
    
    func getBookSectionIDForName(name: String) -> UUID {
        var myReturn:UUID
        let sectionIdNames = getBookSectionsIDNames()
        if sectionIdNames.contains(where: {$0.name == name}) {
            myReturn = sectionIdNames.filter({$0.name == name}).first!.id
        } else {
            fatalError("no uuid for name supplied, fatal")
        }
        
        return myReturn
    }
    
    func getBookSectionNames() -> [String] {
        let sectionIdNames = getBookSectionsIDNames()
        var returningNames: [String] = []
        for abs in sectionIdNames {
            returningNames.append(abs.name)
        }
        return returningNames
    }
    func addRecipe(bsectionid: UUID, recipe: SectionItem) {
        if sections.contains(where: {$0.id == bsectionid}) {
            
            guard let bs = sections.first(where: {$0.id == bsectionid}) else { return }
            var items: [SectionItem] = bs.items
            items.append(recipe)
            let newBS = BookSection(id: bsectionid, name: bs.name, items: items)
            guard let index = sections.firstIndex(where: {$0.id == bsectionid}) else { return }
            sections.remove(at: index)
            
            sections.append(newBS)
#if DEBUG
            print(msgs.aur.rawValue + msgs.chgAdd.rawValue, bs.name)
#endif
        } else {
#if DEBUG
            // sections does not contain id or name
            // get name from built in name for the id supplied
            let nameIDs = self.getBookSectionsIDNames()
            for bsin in nameIDs {
                if bsin.id == bsectionid {
                    let newBS = BookSection(id: bsectionid, name: bsin.name, items: [recipe])
                    sections.append(newBS)
                    let myDocuDirUrl = getDocuDirUrl()
                    let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
                    do {
                        let encodedJSON = try JSONEncoder().encode(newBS)
                        // now write out
                        try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBS.name + "_" + dateSuffix() + json))
#if DEBUG
                        print("Successfully wrote booksection to reczipes directory")
#endif
                        print(msgs.aur.rawValue + msgs.chgNew.rawValue, newBS.name)
                        
                    } catch {
                        // can't save
                        fatalError("Can't save booksection fatal")
                    }
                }
            }
#endif
        }
    }
    
    func removeRecipe(bsectionid: UUID, recipe: SectionItem) {
        if sections.contains(where: {$0.id == bsectionid}) {
            
            guard let bs = sections.first(where: {$0.id == bsectionid}) else { return }
            var items: [SectionItem] = bs.items
            guard let recpIdx = items.firstIndex(of: recipe) else { return }
            items.remove(at: recpIdx)
            
            let newBS = BookSection(id: bsectionid, name: bs.name, items: items)
            guard let index = sections.firstIndex(where: {$0.id == bsectionid}) else { return }
            sections.remove(at: index)
            
            sections.append(newBS)
            
            
#if DEBUG
            print(msgs.aur.rawValue + msgs.chgRem.rawValue, bs.name)
#endif
        }
    }
    
    func add(bsection: BookSection) {
        if !sections.contains(bsection) {  // user may have hit the order button multiple times on the same recipe
            sections.append(bsection)
#if DEBUG
            print(msgs.aur.rawValue + msgs.added.rawValue, bsection.id.description, " ", bsection.name)
#endif
        } else {
#if DEBUG
            print(msgs.aur.rawValue + "Already contains this booksection", bsection.id.description, " ", bsection.name)
#endif
        }
    }
    
    func remove(bsection: BookSection) {
        if let index = sections.firstIndex(of: bsection) {
            sections.remove(at: index)
#if DEBUG
            print(msgs.aur.rawValue + msgs.removed.rawValue, bsection.id.description, " ", bsection.name)
#endif
        }
    }
}
