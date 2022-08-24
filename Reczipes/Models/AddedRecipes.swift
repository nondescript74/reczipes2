//
//  AddedRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation
import SwiftUI

public class AddedRecipes: ObservableObject {
    // MARK: - Local Debug
    var zBug:Bool = false
    // MARK: - Initializer
    init() {
        let fileIO = FileIO()
        let jsonDecoder = JSONDecoder()
        let userAddedBookSectionURLs = fileIO.checkContentsRecipeFolder(recipeFolder: msgs.reczipes.rawValue)
        if userAddedBookSectionURLs.isEmpty {
            // create Reczipes folder in users documents
            _ = fileIO.createRecipeFolders(folderName: msgs.reczipes.rawValue)
            if zBug  {
                print(msgs.ar.rawValue + msgs.created.rawValue )
            }
        }
        var userAddedBookSections:[BookSection] = []
        // get all the shipped recipes
        var totalShippedSectionsPlus = Bundle.main.decode([BookSection].self, from: msgs.recipesFile.rawValue).sorted(by: {$0.name < $1.name})
        // now if there were any saved by user, merge them with the shipped recipes
        for aUrl in userAddedBookSectionURLs {
            let dataAtUrl = fileIO.getFileDataAtUrl(url: aUrl)
            let json = try? jsonDecoder.decode(BookSection.self, from: dataAtUrl)
            if json != nil {
                userAddedBookSections.append(json!)
#if DEBUG
                if zBug  {
                    print(msgs.ar.rawValue + msgs.loaded.rawValue + msgs.changed.rawValue + (json?.name ?? "none") )
                }
#endif
            }
        }
        // now check if booksections are duplicated so move added recipes into the total
        for aUASection in userAddedBookSections {
            if totalShippedSectionsPlus.contains(aUASection) {
                // modify and the one already in total
                let index = totalShippedSectionsPlus.firstIndex(of: aUASection)
                for auitem in aUASection.items {
                    if totalShippedSectionsPlus[index!].items.contains(auitem) {
                        // recipe already exists in shipped, replace with this
                        totalShippedSectionsPlus[index!].items.remove(at: totalShippedSectionsPlus[index!].items.firstIndex(of: auitem)!)
                    } else {
                        
                        
                    }
                    totalShippedSectionsPlus[index!].items.append(auitem)
                }
#if DEBUG
                if zBug  {
                    print(msgs.ar.rawValue + msgs.initAdded.rawValue )
                }
#endif
            } else {
                // add this one to total since total does not contain
                totalShippedSectionsPlus.append(aUASection)
#if DEBUG
                if zBug  {
                    print(msgs.ar.rawValue + msgs.tSDoesNotHave.rawValue + msgs.added.rawValue )
                }
#endif
            }
        }
        self.bookSections = totalShippedSectionsPlus
    }
    // MARK: - Environment
    // MARK: - Publisher
    @Published var bookSections = [BookSection]()
    // MARK: Queue
    private let queue = DispatchQueue(label: "com.headydiscy.reczipes.queue")
    // MARK: - Properties
    fileprivate enum msgs: String {
        case ar = "AddedRecipes: "
        case recipesFile = "recipesShipped.json"
        case reczipes = "Reczipes"
        case added = "Added: "
        case wrote = "Wrote to documents: "
        case tSDoesNotHave = "totalSections does not have, added this booksection"
        case initAdded = "init: aUASection items added to totalSections"
        case failedWrite = "Failed to write to documents folder"
        case created = "Created Reczipes folder in User documents folder"
        case loaded = "Loaded "
        case removed = "Removed: "
        case changed = "Changed: "
        case recipeExists = "Recipe already in added recipes, not added - "
        case recipeRemoved = "Recipe removed from BookSection "
        case recipeDNE = "Recipe does not exist in BookSection, can't remove"
        case zeroitems = "can't have 0 items to be added"
        case exists = "BookSection Already Exists "
        case modifying = "Modifying Existing BookSection "
        case addingfrom = "Adding items from BookSection "
        case addingrecipe = "Adding a recipe "
        case returningbooksections = "Returning BookSections "
        case returningsectionitems = "Returning Recipes "
        case returningsectionnames = "Returning BookSection names  "
        case presetrecipes = "got preset recipes "
        case addedrecipes = "got added recipes "
        case space = " "
        case newsection = "The New BookSection "
        case json = "json"
    }
    
    var totalSections: Int {
#if DEBUG
        if zBug { print(msgs.ar.rawValue + msgs.returningbooksections.rawValue + "\(bookSections.count)") }
#endif
        
        return queue.sync {
            return bookSections.count
        }
    }
    
    // MARK: - Methods
    func getAllRecipes() -> [SectionItem]  {
        // this only returns the added recipes
        var returningSectionItems:[SectionItem] = []
        
        for zBookSection in bookSections {
            returningSectionItems.append(contentsOf: zBookSection.items)
        }
        
#if DEBUG
        if zBug { print(msgs.ar.rawValue + msgs.returningbooksections.rawValue + msgs.addedrecipes.rawValue)}
#endif
        
        return queue.sync {
            return returningSectionItems
        }
    }
    
    func getRecipesInBook(filename: String) -> [SectionItem] {
        var returningSectionItems:[SectionItem] = []
        
        for bookSection in bookSections {
            let bookSectionSectionItems = getRecipesInBookSection(filename: filename, section: bookSection)
            for bookSectionItem in bookSectionSectionItems {
                returningSectionItems.append(bookSectionItem)
            }
        }
        
#if DEBUG
        if zBug { print(msgs.ar.rawValue + msgs.returningsectionitems.rawValue + returningSectionItems.count.description)}
#endif
        
        return queue.sync {
            return returningSectionItems  // all the recipes in a book
        }
    }
    
    func getRecipesInBookSection(filename: String, section: BookSection) -> [SectionItem] {
        var returningSectionItems:[SectionItem] = []
        for sectionz in bookSections.filter({$0.name == filename}) {
            for item in sectionz.items {
                returningSectionItems.append(item)
            }
        }
        return queue.sync {
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.returningsectionitems.rawValue + returningSectionItems.count.description)}
#endif
            
            return returningSectionItems
        }
    }
    
    func getBookSectionWithName(name: String) -> BookSection {
        for bookSection in bookSections {
            if bookSection.name == name {
                return bookSection
            }
        }
        // none exists so must ensure clean create and id handling
        return BookSection(id: UUID(), name: name, items: [])
    }
    
    func addBookSection(bookSection: BookSection) {
        let fileIO = FileIO()
        let jsonEncoder = JSONEncoder()
        if !bookSections.contains(bookSection) {
            // does not contain this booksection, add it to the list
            queue.sync {
                bookSections.append(bookSection)
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.added.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            }
            
        } else {
            // already contains this book section, append items from this into already exisitng
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.exists.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            
//            if let index = bookSections.firstIndex(of: bookSection) {
//                let myBookSectionToModify = bookSections[index]
            for item in bookSections[bookSections.firstIndex(of: bookSection)!].items {
                    self.changeBookSectionAddingRecipe(bookSection: bookSections[bookSections.firstIndex(of: bookSection)!], recipeToAdd: item)
                }
        }
        
        // now write it out to documents for persistence
        let jsonData = try? jsonEncoder.encode(bookSection)
        if jsonData != nil {
            let result = fileIO.writeFileInFolderInDocuments(folderName: msgs.reczipes.rawValue, fileNameToSave: bookSection.name, fileType: msgs.json.rawValue, data: jsonData!)
            if result {
#if DEBUG
    if zBug { print(msgs.ar.rawValue + msgs.wrote.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            } else {
#if DEBUG
   print(msgs.ar.rawValue + msgs.failedWrite.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)
#endif
            }
        }
    }
    
    func removeBookSection(bookSection: BookSection) {
        if let index = bookSections.firstIndex(of: bookSection) {
            _ = queue.sync {
                bookSections.remove(at: index)
            }
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.removed.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
        }
    }
    
    func isRecipeNotUnique(newRecipe: SectionItem, oldRecipe: SectionItem) -> Bool {
        return newRecipe.id == oldRecipe.id
    }
    
    func isRecipeAlreadyIn(newRecipe: SectionItem) -> Bool {
        if getAllRecipes().contains(newRecipe) {
            return true
        } else {
            return false
        }
    }
    
    func changeBookSectionAddingRecipe(bookSection: BookSection, recipeToAdd: SectionItem) {
        if bookSections.firstIndex(of: bookSection) != nil {
                if bookSection.items.contains(recipeToAdd) {
                    // already in nothing to do
#if DEBUG
                    print(msgs.ar.rawValue + msgs.recipeExists.rawValue, recipeToAdd.name)
#endif
                } else {
                    var newBookSection = bookSection
                    newBookSection.items.append(recipeToAdd)
                    self.removeBookSection(bookSection: bookSection)
                    self.addBookSection(bookSection: newBookSection)
#if DEBUG
                    if zBug { print(msgs.ar.rawValue + msgs.modifying.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
                    if zBug { print(msgs.ar.rawValue + msgs.addingrecipe.rawValue)}
#endif
                }
            
        }  else {
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.modifying.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            // booksection does not exist, create new
            queue.sync {
                var myBookSection = bookSection
                myBookSection.items = [recipeToAdd]
                bookSections.append(bookSection)
            }
        }
    }
    
    func changeBookSectionRemovingRecipe(recipe: SectionItem, bookSection: BookSection) {
        var myBookSection = bookSection
        
        if let indx = myBookSection.items.firstIndex(of: recipe)  {
            _ = queue.sync {
                myBookSection.items.remove(at: indx)
            }
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.recipeRemoved.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            
        } else {
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.recipeDNE.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
        }
        
    }
    
    func moveRecipeFromOneBookSectionToOther(recipe: SectionItem, originalBookSection: String, newBookSectionName: String) {
        self.changeBookSectionRemovingRecipe(recipe: recipe, bookSection: bookSections.filter({$0.name == originalBookSection}).first!)
        let bookSectionNames = getBookSectionNames()
        if bookSectionNames.description.lowercased().contains(newBookSectionName.lowercased()) {
            changeBookSectionAddingRecipe(bookSection: bookSections.filter({$0.name == newBookSectionName}).first!, recipeToAdd: recipe)
            changeBookSectionRemovingRecipe(recipe: recipe, bookSection: bookSections.filter({$0.name == originalBookSection}).first!)
        } else {
            self.bookSections.append(BookSection(id: UUID(), name: newBookSectionName, items: [recipe]))
        }
        
        // must write the file to disk
    }
    
//    func constructBookSectionsFromFiles() {
//        var myBookSectionsConstructed:Array<BookSection> = []
//        // contained in recipefolder by BookSection
//        let myBookSectionDirectoryUrls =  FileIO().checkContentsOfDir(dirname: recipeFolderName + delimiterDirs + recipesName)
//
//#if DEBUG
//        if zBug { print(msgs.ar.rawValue  + myBookSectionDirectoryUrls.description)}
//#endif
//
//        for aURLForSection in myBookSectionDirectoryUrls {
//            // each of these is a directory for a section in the list
//
//#if DEBUG
//            if zBug { print(msgs.ar.rawValue + aURLForSection.description)}
//#endif
//
//            let myInsideUrls = FileIO().readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipesName + delimiterDirs + aURLForSection.lastPathComponent) // should be 1 or more BookSections as files stored
//
//#if DEBUG
//            if zBug { print(msgs.ar.rawValue + myInsideUrls.description)}
//#endif
//
//            for aUrl in myInsideUrls {
//                let myFileAsSectionItemDataAtUrl = FileIO().getFileDataAtUrl(url: aUrl)
//
//#if DEBUG
//                if zBug { print(msgs.ar.rawValue + myFileAsSectionItemDataAtUrl.description)}
//#endif
//
//                // check for the BookSection to already be added, if so, add the SectionItem within this BookSection to that existing one
//                // if BookSection does not exist, create one with the currently embedded SectionItem in it
//
//                do {
//                    let myBookSection = try JSONDecoder().decode(BookSection.self, from: myFileAsSectionItemDataAtUrl)
//                    let sectionItemsContained = myBookSection.items  // should only have one item
//                    for aSectionItem in sectionItemsContained {
//                        let containedAlready = myBookSectionsConstructed.filter({$0.id == myBookSection.id})
//
//                        if containedAlready.count > 0 {
//                            let myAlreadyExistingBookSectionId = (containedAlready.first?.id)!  // first found
//                            let myAlreadyExistingBookSectionName = (containedAlready.first?.name)!
//                            let myAlreadyExistingBookSectionItems = containedAlready.first?.items
//                            var myItems = myAlreadyExistingBookSectionItems  // get all the items
//                            myItems?.append(aSectionItem)
//                            let newBookSectionToInsert = BookSection(id: myAlreadyExistingBookSectionId, name: myAlreadyExistingBookSectionName, items: myItems!)
//                            var newSetOfSections = myBookSectionsConstructed.filter({$0.name != newBookSectionToInsert.name})
//                            newSetOfSections.append(newBookSectionToInsert)
//                            myBookSectionsConstructed = newSetOfSections
//                        } else {
//                            myBookSectionsConstructed.append(myBookSection)
//                        }
//                    }
//                } catch {
//                    // cannot decode
//                    print("Cannot decode")
//                }
//            }
//        }
//
//        // we now have an array of BookSections which does not contain duplicates
////        for bookSection in myBookSectionsConstructed {
////            self.addBookSection(bookSection: bookSection)
////        }
//        self.bookSections = myBookSectionsConstructed
//    }
}
