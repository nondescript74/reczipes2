//
//  AllUserRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/26/22.
//

import Foundation
import OSLog

@MainActor
@Observable final class AllUserRecipes {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "AllUserRecipes")
    
    // MARK: - Publisher
    var sections = [BookSection]()
    var sectionsWithSRecipes: [BookSectionSRecipes] = [BookSectionSRecipes]()
    
    // MARK: - Initializer
    init() {
        sections.removeAll()
        let myReczipesDirUrl:URL = getDocuDirUrl().appendingPathComponent(recipesName)
        
        let test = FileManager.default.directoryExists(atUrl: myReczipesDirUrl)
        if !test {
            do {
                try FileManager.default.createDirectory(at: myReczipesDirUrl, withIntermediateDirectories: true)
                
                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: "RecipeNotes"), withIntermediateDirectories: true)
                
                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: "RecipeImages"), withIntermediateDirectories: true)
                
                logger.info("Created Reczipes directory")
                logger.info("Created RecipeNotes directory")
                logger.info("Created RecipeImages directory")

            } catch {
                logger.error("Cannot create directories: \(error.localizedDescription)")
                fatalError("Cannot create directories")
            }
        }
        
        // directories exist
        // get all shipped recipes
        if showShipped {
            sections = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})
            logger.info("using shipped recipes")
        }
        
        do {
            var urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            // skip these folders
            urls = urls.filter({!$0.pathComponents.contains("RecipeNotes")})
            urls = urls.filter({!$0.pathComponents.contains("RecipeImages")})
            
            // get the saved recipes
            //
            if urls.count > 0 {
                logger.info("Found user added recipes count: \(urls.count)")
                for aurl in urls {
                    do {
                        let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(aurl.lastPathComponent))
                        let aBookSection = try JSONDecoder().decode(BookSection.self, from: data)
                        // may need to merge recipes if multiple booksections with same name, different id exist
                        logger.info("Found user added recipe: \(aurl.lastPathComponent)")
                        if sections.contains(where: {$0.name == aBookSection.name}) {
                            var existingBS = sections.first(where: {$0.name == aBookSection.name})
                            for anItem in aBookSection.items {
                                existingBS?.items.append(anItem)
                                logger.info("Merged user added recipe: \(aurl.lastPathComponent)")
                            }
                            var newBSsections = sections.filter({$0.name != aBookSection.name})
                            if (existingBS != nil) {
                                newBSsections.append(existingBS!)
                                logger.info("Existing Booksections appended to new newly created BookSection")
                                sections = newBSsections
                            }
                        } else {
                            sections.append(aBookSection)
                            logger.info("appended user added recipe: to \(aBookSection.name)")
                        }
                    } catch  {
                        // not a json file
                        logger.error("\(error.localizedDescription)")
                        fatalError("This directory has illegal files")
                    }
                }
            } else {
                logger.info("no recipes added by user")
            }
        } catch  {
            // no contents or does not exist
            logger.error("could not get contents of directory or does not exist")
        }
    }
    
    //MARK: - Properties
    
    // MARK: - Methods
    
    fileprivate func getExtractedViaUrl(urlString: String) async -> SRecipe? {
        
        urlComponents = URLComponents(string: urlThings.extractedrecipe.rawValue)!
        urlComponents.query = myQuery.extract.rawValue + urlString + myQuery.anlyztrue.rawValue + myQuery.forceExtracttrue.rawValue + (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")
        let getSRecipeUrl = urlComponents.url
        logger.info("getExtractedViaUrl url generated")
        do {
            let (data, _) = try await URLSession.shared.data(from: getSRecipeUrl!)
            // check for empty array
            if data.isEmpty {
                logger.info("Empty Data")
                return nil
            }
            let sRecipe = try JSONDecoder().decode(SRecipe.self, from: data)
            logger.info("decoded SRecipe")
            return sRecipe
            
        } catch  {
            logger.error("\(error.localizedDescription)")
            return nil
        }
    }
    
    fileprivate func getBookSectionsIDNames() -> [BookSectionIDName] {
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
    
    @MainActor
    func addRecipe(bsectionid: UUID, recipe: SectionItem3) -> Bool {
        var myReturn: Bool = false
        // is the recipe in any section
        var items: [SectionItem3] = [SectionItem3]()
        for abs in sections {
            items.append(contentsOf: abs.items)
            if items.contains(recipe) {
                logger.info("This recipe is already saved")
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
            
            myReturn = encInto(newBsec: newBS)
            logger.info("encoded into existing booksection")
        } else {
            
            // sections does not contain id or name
            // get name from built in name for the id supplied
            let nameIDs = self.getBookSectionsIDNames()
            for bsin in nameIDs {
                if bsin.id == bsectionid {
                    let newBS = BookSection(id: bsectionid, name: bsin.name, items: [recipe])
                    add(bsection: newBS)
                    logger.info("added new booksection with added recipe")
                    myReturn = encInto(newBsec: newBS)
                }
            }
        }
        return myReturn
    }
    
    fileprivate func encInto(newBsec: BookSection) -> Bool {
        do {
            let encodedJSON = try JSONEncoder().encode(newBsec)
            // now write out
            try encodedJSON.write(to: getDocuDirUrl().appendingPathComponent(recipesName).appendingPathComponent(newBsec.name + json))
            logger.info("encoded into existing booksection")
        } catch {
            // can't save
            logger.error("\(error.localizedDescription)")
            fatalError("Can't save booksection fatal")
        }
        return true
    }
    
    @MainActor
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
            logger.info("removed recipe from booksection")
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
        logger.info("returning \(myReturn.count) recipe names")
        return myReturn
    }
    
    func getBookSections() -> [BookSection] {
        return sections
    }
    
    fileprivate func add(bsection: BookSection) {
        if !sections.contains(bsection) {  // user may have hit the order button multiple times on the same recipe
            sections.append(bsection)
            logger.info("added booksection")
        } else {
            logger.info("already contains this booksection, not added")
        }
    }
    
    fileprivate func remove(bsection: BookSection) {
        if let index = sections.firstIndex(of: bsection) {
            sections.remove(at: index)
            logger.info("removed booksection")
        }
    }
    
    func loadFromUrls() async {
        let urlStrings: [String] = Bundle.main.decode([String].self, from: "recipesShippedUrls.json")
        for aurlString in urlStrings {
            let sRecipe = await getExtractedViaUrl(urlString: aurlString)
            if sRecipe != nil {
                 if sectionsWithSRecipes.contains(where: {$0.name == "Other"}) {
                    // Other section exists so use it to append the SRecipe just obtained
                    var newSection = sectionsWithSRecipes.first(where: {$0.name == "Other"})!
                    newSection.srecipes.append(sRecipe!)
                    sectionsWithSRecipes[sectionsWithSRecipes.firstIndex(of: sectionsWithSRecipes.first(where: {$0.name == "Other"})!)!] = newSection
                     logger.info( "SRecipe cuisines are not recognized, adding SRecipe to existing Other section")
                } else  {
                    // first time thru, create a section called Other and add the obtained SRecipe
                    let newSection: BookSectionSRecipes = BookSectionSRecipes(id: getBookSectionIDForName(name: "Other"), name: "Other", srecipes: [sRecipe!])
                    sectionsWithSRecipes.append(newSection)
                    logger.info( "SRecipe cuisines are not recognized, creating a new Other section and adding SRecipe")
                }
            }
        }
        logger.info("added recipes from urls")
    }
}
