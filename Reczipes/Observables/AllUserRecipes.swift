//
//  AllUserRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/26/22.
//

import Foundation

class AllUserRecipes: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true

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
                
#if DEBUG && zBug
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
        if showShipped {
            sections = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})
#if DEBUG && zBug
            print(msgs.aur.rawValue + "using shipped recipes")
#endif
        }
        let fmapsections = sections.compactMap({$0})
        let secItems = fmapsections.flatMap({$0.items})
#if DEBUG && zBug
        print(msgs.aur.rawValue + "Number of shipped recipes is : " + "\(secItems.count)")
#endif
        
        do {
            var urls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(recipesName), includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            // skip these folders
            urls = urls.filter({!$0.pathComponents.contains(msgs.rnotes.rawValue)})
            urls = urls.filter({!$0.pathComponents.contains(msgs.rimages.rawValue)})
            
            if urls.count > 0 {
#if DEBUG && zBug
                print(msgs.aur.rawValue + "urls added by user is non zero")
#endif
                for aurl in urls {
                    do {
                        let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(aurl.lastPathComponent))
                        let aBookSection = try JSONDecoder().decode(BookSection.self, from: data)
                        // may need to merge recipes if multiple booksections with same name, different id exist
#if DEBUG && zBug
                        print(msgs.aur.rawValue + msgs.fuar.rawValue)
#endif
                        if sections.contains(where: {$0.name == aBookSection.name}) {
                            var existing = sections.first(where: {$0.name == aBookSection.name})
                            
                            for anItem in aBookSection.items {
                                //                            if secItems.contains(anItem) {
                                //                                 don't add it
                                //#if DEBUG
                                //                                print(msgs.aur.rawValue + " duplicate SectionItem, not adding " + anItem.name)}
                                //#endif
                                //                            } else {
                                existing?.items.append(anItem)
                                //                            }
                            }
                            sections = sections.filter({$0.name != aBookSection.name})
                            if (existing != nil) {
                                sections.append(existing!)
#if DEBUG && zBug
                                print(msgs.aur.rawValue + msgs.combined.rawValue)
#endif
                            }
                        } else {
                            sections.append(aBookSection)
#if DEBUG && zBug
                            print(msgs.aur.rawValue + msgs.added.rawValue + aBookSection.name)
#endif
                        }
                    } catch  {
                        // not a json file
                        fatalError("This directory has illegal files")
                    }
                }
            } else {
#if DEBUG && zBug
                print(msgs.aur.rawValue + "no recipes added by user")
#endif
            }
        } catch  {
            // no contents or does not exist
#if DEBUG && zBug
            print(msgs.aur.rawValue + "could not get contents of directory")
#endif
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
            myReturn = sectionIdNames.filter({$0.name == "Other"}).first!.id
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
    
    func getRecipeForName(name: String) -> SectionItem3? {
        var myReturn: SectionItem3?
        let recnams = getRecipeNames()
        if recnams.contains(name) {
            var items = [SectionItem3]()
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
//                returnUrls.append(URL(fileURLWithPath: aUrl))
                returnUrls.append(URL(string: aUrl)!)
#if DEBUG && zBug
                print(msgs.aur.rawValue + msgs.urls.rawValue + aUrl)
#endif
            }
        }
        
        return returnUrls
    }
    
    @MainActor
    func addRecipe(bsectionid: UUID, recipe: SectionItem3) -> Bool {
        var myReturn: Bool = false
        // is the recipe in any section
        var items: [SectionItem3] = [SectionItem3]()
        for abs in sections {
            items.append(contentsOf: abs.items)
            if items.contains(recipe) {
#if DEBUG && zBug
                print(msgs.aur.rawValue + "This recipe is already saved")
#endif
                return myReturn
            }
        }
        
        if sections.contains(where: {$0.id == bsectionid}) {
            let bs = sections.first(where: {$0.id == bsectionid})
            var items: [SectionItem3] = bs!.items
            items.append(recipe)
            let newBS = BookSection(id: bsectionid, name: bs!.name, items: items)
            
            remove(bsection: bs!)
            add(bsection: newBS)
            
            _ = encInto(newBsec: newBS)
            myReturn = true
            
#if DEBUG && zBug
                print(msgs.aur.rawValue + "added recipe to existing booksection")
#endif
            
        } else {
            
            // sections does not contain id or name
            // get name from built in name for the id supplied
            let nameIDs = self.getBookSectionsIDNames()
            for bsin in nameIDs {
                if bsin.id == bsectionid {
                    let newBS = BookSection(id: bsectionid, name: bsin.name, items: [recipe])
                    add(bsection: newBS)
#if DEBUG && zBug
                print(msgs.aur.rawValue + "added new booksection with added recipe", bsin.name, " ", recipe.name)
#endif
                    myReturn = encInto(newBsec: newBS)
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
#if DEBUG && zBug
            print(msgs.aur.rawValue + msgs.enc.rawValue, newBsec.name)
#endif
        } catch {
            // can't save
            fatalError("Can't save booksection fatal")
        }
        return true
    }
    
    func removeRecipe(bsectionid: UUID, recipe: SectionItem3) {
        if sections.contains(where: {$0.id == bsectionid}) {
            
            guard let bs = sections.first(where: {$0.id == bsectionid}) else { return }
            var items: [SectionItem3] = bs.items
            guard let recpIdx = items.firstIndex(of: recipe) else { return }
            items.remove(at: recpIdx)
            
            let newBS = BookSection(id: bsectionid, name: bs.name, items: items)
            guard let index = sections.firstIndex(where: {$0.id == bsectionid}) else { return }
            sections.remove(at: index)
            
            sections.append(newBS)
            
#if DEBUG && zBug
            print(msgs.aur.rawValue + msgs.chgRem.rawValue, bs.name)
#endif
        }
    }
    
    func getRecipeNameForId(uuidsent: UUID) -> String {
        var myReturn: String = ""
        var mySItems: [SectionItem3] = []
        for asection in sections {
            mySItems += asection.items
        }
        myReturn = mySItems.filter({$0.id == uuidsent}).first?.name ?? "No name for id supplied"
        
#if DEBUG && zBug
        print(msgs.aur.rawValue + "returning name for id ", myReturn)
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
#if DEBUG && zBug
        print(msgs.aur.rawValue + msgs.retr.rawValue, myReturn.count)
#endif
        return myReturn
    }
    
    func add(bsection: BookSection) {
        if !sections.contains(bsection) {  // user may have hit the order button multiple times on the same recipe
            sections.append(bsection)
#if DEBUG && zBug
            print(msgs.aur.rawValue + msgs.added.rawValue, bsection.id.description, " ", bsection.name)
#endif
        } else {
#if DEBUG && zBug
            print(msgs.aur.rawValue + "Already contains this booksection", bsection.id.description, " ", bsection.name)
#endif
        }
    }
    
    func remove(bsection: BookSection) {
        if let index = sections.firstIndex(of: bsection) {
            sections.remove(at: index)
#if DEBUG && zBug
            print(msgs.aur.rawValue + msgs.removed.rawValue, bsection.id.description, " ", bsection.name)
#endif
        }
    }
}
