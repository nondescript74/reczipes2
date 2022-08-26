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
        let resultBaseFolder = fileIO.createRecipeFolders()
        let jsonDecoder = JSONDecoder()
        let userAddedBookSectionURLs = fileIO.checkContentsReczipesFolder()
        var userAddedBookSections:[BookSection] = []
        if userAddedBookSectionURLs.isEmpty {
//            // create Reczipes folder in users documents
//            let result = fileIO.createRecipeFolders(folderName: msgs.reczipes.rawValue)
//            if result {
//                if zBug  {
//                    print(msgs.ar.rawValue + msgs.created.rawValue )
//                }
//            }
        } else {
            // now if there were any saved by user, merge them with the shipped recipes
            for aUrl in userAddedBookSectionURLs {
                if aUrl.absoluteString.contains(recipeNotesFolderName) || aUrl.absoluteString.contains(recipeImagesFolderName) {
                    // nothing to do this is a note or image
                } else {
                    // ok, get the user added recipe
                    // it is possible for the user to have added notes or images to shipped recipes without adding any recipes
                    if zBug { print(msgs.ar.rawValue + msgs.skipped.rawValue)}
                    
                    let dataAtUrl = fileIO.getFileDataAtUrl(url: aUrl)
                    let json = try? jsonDecoder.decode(BookSection.self, from: dataAtUrl)
                    if json != nil {
                        userAddedBookSections.append(json!)

                        if zBug { print(msgs.ar.rawValue + msgs.loaded.rawValue + msgs.changed.rawValue + (json?.name ?? "none"))}

                    }
                }

            }
            
        }
        
        // get all the shipped recipes
        var totalShippedSectionsPlus = Bundle.main.decode([BookSection].self, from: msgs.recipesFile.rawValue).sorted(by: {$0.name < $1.name})

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

                if zBug  {
                    print(msgs.ar.rawValue + msgs.initAdded.rawValue )
                }

            } else {
                // add this one to total since total does not contain
                totalShippedSectionsPlus.append(aUASection)

                if zBug  {
                    print(msgs.ar.rawValue + msgs.tSDoesNotHave.rawValue + msgs.added.rawValue )
                }

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
        case skipped = "Skipped due to note or image"
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
        if zBug { print(msgs.ar.rawValue + msgs.returningbooksections.rawValue + "\(bookSections.count)") }
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
        if zBug { print(msgs.ar.rawValue + msgs.returningbooksections.rawValue + msgs.addedrecipes.rawValue)}

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
        

        if zBug { print(msgs.ar.rawValue + msgs.returningsectionitems.rawValue + returningSectionItems.count.description)}

        
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
            if zBug { print(msgs.ar.rawValue + msgs.returningsectionitems.rawValue + returningSectionItems.count.description)}
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
                if zBug { print(msgs.ar.rawValue + msgs.added.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
            }
        } else {
            // already contains this book section, append items from this into already exisitng
            if zBug { print(msgs.ar.rawValue + msgs.exists.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}

            for item in bookSections[bookSections.firstIndex(of: bookSection)!].items {
                self.changeBookSectionAddingRecipe(bookSection: bookSections[bookSections.firstIndex(of: bookSection)!], recipeToAdd: item)
            }
        }
        
        // now write it out to documents for persistence
        let jsonData = try? jsonEncoder.encode(bookSection)
        if jsonData != nil {
            let result = fileIO.writeFileInFolderInDocuments(folderName: msgs.reczipes.rawValue, fileNameToSave: bookSection.name, fileType: msgs.json.rawValue, data: jsonData!)
            if result {
                if zBug { print(msgs.ar.rawValue + msgs.wrote.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
            } else {
                print(msgs.ar.rawValue + msgs.failedWrite.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)
            }
        } else {
            print("Can't encode recipe, not saved to disk")
        }
    }
    
    func removeBookSection(bookSection: BookSection) {
        if let index = bookSections.firstIndex(of: bookSection) {
            _ = queue.sync {
                bookSections.remove(at: index)
            }
            if zBug { print(msgs.ar.rawValue + msgs.removed.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
            let fileIO = FileIO()
            fileIO.removeFileInRecipeFolder(recipeFolder: msgs.reczipes.rawValue, fileName: bookSection.name)
        } else {
            // does not exist, nothing to do
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
                print(msgs.ar.rawValue + msgs.recipeExists.rawValue, recipeToAdd.name)
            } else {
                var newBookSection = bookSection
                newBookSection.items.append(recipeToAdd)
                queue.sync {
                    self.removeBookSection(bookSection: bookSection)
                    self.addBookSection(bookSection: newBookSection)

                    if zBug { print(msgs.ar.rawValue + msgs.modifying.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
                    if zBug { print(msgs.ar.rawValue + msgs.addingrecipe.rawValue)}
                }
            }
        }  else {
            if zBug { print(msgs.ar.rawValue + msgs.modifying.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
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
            if zBug { print(msgs.ar.rawValue + msgs.recipeRemoved.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
        } else {
            if zBug { print(msgs.ar.rawValue + msgs.recipeDNE.rawValue, bookSection.id.description, msgs.space.rawValue, bookSection.name)}
        }
    }
    
    func moveRecipeFromOneBookSectionToOther(recipe: SectionItem, originalBookSectionName: String, newBookSectionName: String) {
        if bookSections.filter({$0.name == newBookSectionName}).first != nil {
            // check if the two booksections are identical
            if originalBookSectionName != newBookSectionName {
                //                self.changeBookSectionRemovingRecipe(recipe: recipe, bookSection: bookSections.filter({$0.name == originalBookSectionName}).first!)
                self.changeBookSectionAddingRecipe(bookSection: bookSections.filter({$0.name == newBookSectionName}).first!, recipeToAdd: recipe)
            } else {
                // booksections are identical, no move required
            }
        } else {
            // BookSection does not exist
            if bookSections.filter({$0.name == originalBookSectionName}).first != nil {
                // section exists, remove recipe from original
                self.changeBookSectionRemovingRecipe(recipe: recipe, bookSection: bookSections.filter({$0.name == originalBookSectionName}).first!)
            }
            queue.sync {
                self.bookSections.append(BookSection(id: UUID(), name: newBookSectionName, items: [recipe]))
            }
        }
    }
}
