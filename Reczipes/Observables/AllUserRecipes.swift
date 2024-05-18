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
                if zBug {print("FileManager: " + " Created Reczipes directory")}
                if zBug {print("FileManager: " + " Created RecipeNotes directory")}
                if zBug {print("FileManager: " + " Created RecipeImages directory")}
#endif
            } catch {
                fatalError("Cannot create directories")
            }
        }
        
        // directories exist
        // get all shipped recipes
        sections = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})
        let fmapsections = sections.compactMap({$0})
        let secItems = fmapsections.flatMap({$0.items})
#if DEBUG
        if zBug {print(msgs.aur.rawValue + "Number of shipped recipes is : " + "\(secItems.count)")}
#endif
        
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
                    if zBug {print(msgs.aur.rawValue + msgs.fuar.rawValue)}
#endif
                    if sections.contains(where: {$0.name == aBookSection.name}) {
                        var existing = sections.first(where: {$0.name == aBookSection.name})
                        
                        for anItem in aBookSection.items {
//                            if secItems.contains(anItem) {
//                                 don't add it
//#if DEBUG
//                                if zBug {print(msgs.aur.rawValue + " duplicate SectionItem, not adding " + anItem.name)}
//#endif
//                            } else {
                                existing?.items.append(anItem)
//                            }
                        }
                        sections = sections.filter({$0.name != aBookSection.name})
                        if (existing != nil) {
                            sections.append(existing!)
#if DEBUG
                            if zBug {print(msgs.aur.rawValue + msgs.combined.rawValue)}
#endif
                        }
                    } else {
                        sections.append(aBookSection)
#if DEBUG
                        if zBug {print(msgs.aur.rawValue + msgs.added.rawValue + aBookSection.name)}
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
        case enc = "Encoded: "
        case added = "Added: "
        case removed = "Removed: "
        case chgRem = "Changed, removed recipe: "
        case total = "Total: "
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case fuar = "Found user added recipe"
        case combined = "Combined booksections into one booksection"
        case retr = "Returning count of recipes: "
        case urls = "Returning urls of recipes: "
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
    
    func getRecipeForName(name: String) -> SectionItem2? {
        var myReturn: SectionItem2?
        let recnams = getRecipeNames()
        if recnams.contains(name) {
            var items = [SectionItem2]()
            for abs in sections {
                items = items + abs.items
            }
            for asItem in items {
                if asItem.name == name {
                    myReturn = asItem
                }
            }
            
        } else {
            // returning nil
        }
        return myReturn
    }
    
    func getRecipeUrls() -> [URL] {
        var returnUrls = [URL]()
        for aBookSection in sections {
            let sectionItemUrls = aBookSection.items.map { $0.url }
            for aUrl in sectionItemUrls {
                returnUrls.append(URL(fileURLWithPath: aUrl))
#if DEBUG
                print(msgs.aur.rawValue + msgs.urls.rawValue + aUrl)
#endif
            }
        }
        
        return returnUrls
    }
    
    @MainActor
    func addRecipe(bsectionid: UUID, recipe: SectionItem2) -> Bool {
        var myReturn: Bool = false
        // is the recipe in any section
        var items: [SectionItem2] = [SectionItem2]()
        for abs in sections {
            items.append(contentsOf: abs.items)
            if items.contains(recipe) {
#if DEBUG
                if zBug {print(msgs.aur.rawValue + "This recipe is already saved")}
#endif
                return myReturn
            }
        }
        
        if sections.contains(where: {$0.id == bsectionid}) {
            let bs = sections.first(where: {$0.id == bsectionid})
            var items: [SectionItem2] = bs!.items
            items.append(recipe)
            let newBS = BookSection(id: bsectionid, name: bs!.name, items: items)
            
            remove(bsection: bs!)
            add(bsection: newBS)
            
            _ = encInto(newBsec: newBS)
            myReturn = true
            
            
        } else {
            
            // sections does not contain id or name
            // get name from built in name for the id supplied
            let nameIDs = self.getBookSectionsIDNames()
            for bsin in nameIDs {
                if bsin.id == bsectionid {
                    let newBS = BookSection(id: bsectionid, name: bsin.name, items: [recipe])
                    add(bsection: newBS)
                    
                    _ = encInto(newBsec: newBS)
                    myReturn = true
                }
            }
        }
        sections = sections.sorted(by: {$0.name < $1.name})
        return myReturn
    }
    
    fileprivate func encInto(newBsec: BookSection) -> Bool {
        do {
            let encodedJSON = try JSONEncoder().encode(newBsec)
            // now write out
            try encodedJSON.write(to: getDocuDirUrl().appendingPathComponent(recipesName).appendingPathComponent(newBsec.name + json))
            
#if DEBUG
            if zBug {print(msgs.aur.rawValue + msgs.enc.rawValue, newBsec.name)}
#endif
        } catch {
            // can't save
            fatalError("Can't save booksection fatal")
        }
        return false
    }
    
    func removeRecipe(bsectionid: UUID, recipe: SectionItem2) {
        if sections.contains(where: {$0.id == bsectionid}) {
            
            guard let bs = sections.first(where: {$0.id == bsectionid}) else { return }
            var items: [SectionItem2] = bs.items
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
    
    func getRecipeNameForId(uuidsent: UUID) -> String {
        var myReturn: String = ""
        var mySItems: [SectionItem2] = []
        for asection in sections {
            mySItems += asection.items
        }
        myReturn = mySItems.filter({$0.id == uuidsent}).first?.name ?? "No name for id supplied"
        
#if DEBUG
        if zBug {print(msgs.aur.rawValue + "returning name for id ", myReturn)}
#endif
        return myReturn
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
        if zBug {print(msgs.aur.rawValue + msgs.retr.rawValue, myReturn.count)}
#endif
        return myReturn
    }
    
    func add(bsection: BookSection) {
        if !sections.contains(bsection) {  // user may have hit the order button multiple times on the same recipe
            sections.append(bsection)
#if DEBUG
            if zBug {print(msgs.aur.rawValue + msgs.added.rawValue, bsection.id.description, " ", bsection.name)}
#endif
        } else {
#if DEBUG
            if zBug {print(msgs.aur.rawValue + "Already contains this booksection", bsection.id.description, " ", bsection.name)}
#endif
        }
    }
    
    func remove(bsection: BookSection) {
        if let index = sections.firstIndex(of: bsection) {
            sections.remove(at: index)
#if DEBUG
            if zBug {print(msgs.aur.rawValue + msgs.removed.rawValue, bsection.id.description, " ", bsection.name)}
#endif
        }
    }
}
