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
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let test = FileManager.default.directoryExists(atUrl: myReczipesDirUrl)
        if !test {
            do {
                try FileManager.default.createDirectory(at: myReczipesDirUrl, withIntermediateDirectories: true)
                
                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: msgs.rnotes.rawValue), withIntermediateDirectories: true)
                
                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: msgs.rimages.rawValue), withIntermediateDirectories: true)
                
#if DEBUG
                print("FileManager: " + " Created Reczipes directory")
                print("FileManager: " + " Created RecipeNotes directory")
                print("FileManager: " + " Created RecipeImages directory")
#endif
                
            } catch {
                fatalError("Cannot create directories")
            }

        }
        
        // directories exist
        
        // get all shipped recipes
        sections = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})

        
        do {
            var urls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(recipesName), includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            // skip these folders
            urls = urls.filter({!$0.pathComponents.contains(msgs.rnotes.rawValue)})
            urls = urls.filter({!$0.pathComponents.contains(msgs.rimages.rawValue)})
            
            
            for aurl in urls {
                do {
                    let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(aurl.lastPathComponent))
                    let aBookSection = try JSONDecoder().decode(BookSection.self, from: data)
                    // may need to merge recipes if multiple booksections with same name, different id exist
#if DEBUG
                    if zBug {print(msgs.ext.rawValue + msgs.fuar.rawValue)}
#endif
                    if sections.contains(where: {$0.name == aBookSection.name}) {
                        var existing = sections.first(where: {$0.name == aBookSection.name})
                        existing?.items.append(contentsOf: aBookSection.items)
                        sections = sections.filter({$0.name != aBookSection.name})
                        if (existing != nil) {
                            sections.append(existing!)
#if DEBUG
                            if zBug {print(msgs.ext.rawValue + msgs.combined.rawValue)}
#endif
                        }
                    } else {
                        sections.append(aBookSection)
#if DEBUG
                        if zBug {print(msgs.ext.rawValue + msgs.added.rawValue + aBookSection.name)}
#endif
                    }
                } catch  {
                    // not a json file
                    fatalError("This directory has illegal files")
                }
            }
        } catch  {
            // no contents or does not exist
        }
        
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
        case rshipd = "recipesShipped"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case fuar = "Found user added recipe"
        case combined = "Combined booksections into one booksection"
        case ext = "Extensions: "
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
//            sections = sections.sorted(by: {$0.name < $1.name})
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
        
        sections = sections.sorted(by: {$0.name < $1.name})
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
    
    func getRecipeNames() -> [String] {
        var myReturn: [String] = []
        for asection in sections {
            let sectionItems = asection.items
            for sectionItem in sectionItems {
                myReturn.append(sectionItem.name)
            }
        }
#if DEBUG
        print(msgs.aur.rawValue + "Returning count of recipes: ", myReturn.count)
#endif
        return myReturn
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
