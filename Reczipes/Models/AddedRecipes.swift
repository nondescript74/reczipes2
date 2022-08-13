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
    var zBug2:Bool = true
    // MARK: - Initializer
    init() {
        let totalSections = Bundle.main.decode([BookSection].self, from: msgs.recipesFile.rawValue).sorted(by: {$0.name < $1.name})
        self.bookSections = totalSections
    }

    // MARK: - Environment
    // MARK: - Publisher
    @Published var bookSections = [BookSection]()
    // MARK: Queue
    private let queue = DispatchQueue(label: "com.headydiscy.reczipes.addedrecipes.queue")
    // MARK: - Properties
    fileprivate enum msgs: String {
        case ar = "AddedRecipes: "
        case recipesFile = "recipesShipped.json"
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case recipeExists = "Recipe already in added recipes, not added - "
        case zeroitems = "can't have 0 items to be added"
        case exists = "BookSection Already Exists "
        case modifying = "Modifying Existing BookSection "
        case addingfrom = "Adding items from BookSection "
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
    
    func addBookSection(bookSection: BookSection) {
        if !bookSections.contains(bookSection) {
            
            queue.sync {
                bookSections.append(bookSection)
            }
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.added.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            
        } else {
            // already contains this book section, append items from this into already exisitng
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.exists.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            
            if let index = bookSections.firstIndex(of: bookSection) {
                let myBookSectionToModify = bookSections[index]
                self.changeBookSection(bookSection: myBookSectionToModify, addingItemsFrom: bookSection)
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
    
    func changeBookSection(bookSection: BookSection, addingItemsFrom: BookSection)  {
        if bookSections.firstIndex(of: bookSection) != nil {
//            let myBookSectionToModify = bookSections[index]
//            let myExistingRecipes = myBookSectionToModify.items
            let recipeToAdd = addingItemsFrom.items.first
            if (recipeToAdd != nil) {  // should contain
                if bookSection.items.contains(recipeToAdd!) {
                    // already in nothing to do
#if DEBUG
                    print(msgs.ar.rawValue + msgs.recipeExists.rawValue, recipeToAdd!.name)
#endif
                } else {
                    var newBookSection = bookSection
                    newBookSection.items.append(recipeToAdd!)
                    self.removeBookSection(bookSection: bookSection)
                    self.addBookSection(bookSection: newBookSection)
#if DEBUG
                    if zBug { print(msgs.ar.rawValue + msgs.modifying.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
                    if zBug { print(msgs.ar.rawValue + msgs.addingfrom.rawValue, addingItemsFrom.id.description, msgs.space.rawValue, addingItemsFrom.name)}
                    if zBug { print(msgs.ar.rawValue + msgs.newsection.rawValue, newBookSection.id.description, msgs.space.rawValue, newBookSection.name)}
#endif
                }
            } else {
                fatalError(msgs.ar.rawValue + msgs.zeroitems.rawValue)
            }
            
            
        }  else {
#if DEBUG
            if zBug { print(msgs.ar.rawValue + msgs.modifying.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
#endif
            // booksection does not exist, create new
            queue.sync {
                bookSections.append(addingItemsFrom)
            }
        }
    }
    
    func constructBookSectionsFromFiles() {
        var myBookSectionsConstructed:Array<BookSection> = []
        // contained in recipefolder by BookSection
        let myBookSectionDirectoryUrls =  FileIO().checkContentsOfDir(dirname: recipeFolderName + delimiterDirs + recipesName)
        
#if DEBUG
        if zBug { print(msgs.ar.rawValue  + myBookSectionDirectoryUrls.description)}
#endif
        
        for aURLForSection in myBookSectionDirectoryUrls {
            // each of these is a directory for a section in the list
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + aURLForSection.description)}
#endif
            
            let myInsideUrls = FileIO().readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipesName + delimiterDirs + aURLForSection.lastPathComponent) // should be 1 or more BookSections as files stored
            
#if DEBUG
            if zBug { print(msgs.ar.rawValue + myInsideUrls.description)}
#endif
            
            for aUrl in myInsideUrls {
                let myFileAsSectionItemDataAtUrl = FileIO().getFileDataAtUrl(url: aUrl)
                
#if DEBUG
                if zBug { print(msgs.ar.rawValue + myFileAsSectionItemDataAtUrl.description)}
#endif
                
                // check for the BookSection to already be added, if so, add the SectionItem within this BookSection to that existing one
                // if BookSection does not exist, create one with the currently embedded SectionItem in it
                
                do {
                    let myBookSection = try JSONDecoder().decode(BookSection.self, from: myFileAsSectionItemDataAtUrl)
                    let sectionItemsContained = myBookSection.items  // should only have one item
                    for aSectionItem in sectionItemsContained {
                        let containedAlready = myBookSectionsConstructed.filter({$0.id == myBookSection.id})
                        
                        if containedAlready.count > 0 {
                            let myAlreadyExistingBookSectionId = (containedAlready.first?.id)!  // first found
                            let myAlreadyExistingBookSectionName = (containedAlready.first?.name)!
                            let myAlreadyExistingBookSectionItems = containedAlready.first?.items
                            var myItems = myAlreadyExistingBookSectionItems  // get all the items
                            myItems?.append(aSectionItem)
                            let newBookSectionToInsert = BookSection(id: myAlreadyExistingBookSectionId, name: myAlreadyExistingBookSectionName, items: myItems!)
                            var newSetOfSections = myBookSectionsConstructed.filter({$0.name != newBookSectionToInsert.name})
                            newSetOfSections.append(newBookSectionToInsert)
                            myBookSectionsConstructed = newSetOfSections
                        } else {
                            myBookSectionsConstructed.append(myBookSection)
                        }
                    }
                } catch {
                    // cannot decode
#if DEBUG
                    print("Cannot decode")
#endif
                }
            }
        }
        
        // we now have an array of BookSections which does not contain duplicates
        for bookSection in myBookSectionsConstructed {
            self.addBookSection(bookSection: bookSection)
        }
    }
}
