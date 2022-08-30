//
//  FileMgr.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/27/22.
//

import Foundation

public class FileMgr: FileManager, ObservableObject {
    // MARK: Debug local
    private var zBug:Bool = true
    // MARK: - Initializer
    override init() {
        super.init()
        if createRecipesFolder() {
            // success
        } else {
            fatalError("Could not createRecipesFolder")
        }
    }
    // MARK: Queue
    private let queue = DispatchQueue(label: "com.headydiscy.reczipes.queue")
    // MARK: - Publisher
    // MARK: - Properties
    var fileManager = FileManager.default  // we use this shared unique instance
    fileprivate enum msgs:String {
        case fm = "FileMgr: "
        case recz = "Reczipes"
        case docudir = "Documents directory "
        case rshipd = "recipesShipped"
        case notesshipd = "Notes"
        case imagesshipd = "Images"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case dFolderExists = "Documents folder exists"
        case rFolderExists = "Reczipes folder already exists"
        case rFolderCreated = "Reczipes folder created "
        case rNotesFolderCreated = "RecipeNotes Folder created "
        case reNotesFolderExists = "RecipeNotes Folder already exists "
        case rImagesFolderCreated = "RecipeImages Folder created "
        case rImagesFolderExists = "RecipeImages Folder already exists "
        case json = ".json"
        case gbss = "Got shipped booksections"
        case fuar = "Found user added recipe"
        case nur = "No user recipes"
        case nunotes = "No user notes"
        case nuimages = "No user images"
        case fanote = "Found a note"
        case faimage = "Found an image"
        case wrjson = "Successfully wrote booksection"
        case fail = "Failed"
        case succes = "Success"
        case ccRFolder = "checkContentsReczFolder"
    }
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    
    // MARK: - Methods
    func createRecipesFolder() -> Bool {
        var myReturn: Bool = false
        let myDocuDirUrl:URL?
        
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
            if zBug { print(msgs.fm.rawValue + msgs.dFolderExists.rawValue )}
        } catch {
            // no Documents Dir???
            fatalError()
        }
        
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: recipesName)
        if fileManager.fileExists(atPath: myReczipesDirUrl.absoluteString) {
            if zBug { print(msgs.fm.rawValue + msgs.rFolderExists.rawValue)}
            // directory for notes exists
            // check for images
        }
        
        let myReczNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        if fileManager.fileExists(atPath: myReczNotesDirUrl.absoluteString) {
            if zBug { print(msgs.fm.rawValue + msgs.reNotesFolderExists.rawValue)}
            // directory for notes exists
            // check for images
        } else {
            // create notes folder
            do {
                try fileManager.createDirectory(at: myReczNotesDirUrl, withIntermediateDirectories: true)
                if zBug { print(msgs.fm.rawValue + msgs.rNotesFolderCreated.rawValue)}
            } catch  {
                fatalError()
            }
        }
        let myReczImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        if fileManager.fileExists(atPath: myReczImagesDirUrl.absoluteString, isDirectory: &isDirectory) {
            if zBug { print(msgs.fm.rawValue + msgs.rImagesFolderExists.rawValue)}
            // directory for notes exists
            // all folders exist
        } else {
            // create notes folder
            do {
                _ = try fileManager.createDirectory(at: myReczImagesDirUrl, withIntermediateDirectories: true)
                if zBug { print(msgs.fm.rawValue + msgs.rImagesFolderCreated.rawValue)}
            } catch  {
                fatalError()
            }
            
        }
        myReturn = true
        return myReturn
    }
    func checkDocuDirContents() -> [URL] {
        do {
            let myDocuDirUrl = try fileManager.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
            
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: myDocuDirUrl, includingPropertiesForKeys: nil)
                if zBug { print(msgs.fm.rawValue + msgs.docudir.rawValue + fileURLs.debugDescription, fileURLs.count.description)}
                
                return fileURLs
            } catch {
                fatalError(msgs.fm.rawValue + msgs.fail.rawValue)
            }
        } catch {
            fatalError(msgs.fm.rawValue + msgs.fail.rawValue)
        }
    }
    
    func checkContentsReczipesFolder() -> [URL] {
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(recipesName)
            let contentsRFD = try FileManager.default.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            if zBug { print(msgs.fm.rawValue + msgs.rFolderExists.rawValue, contentsRFD.count)}
            let f1 = contentsRFD.filter({!$0.pathComponents.contains(msgs.rnotes.rawValue)})
            let f2 = f1.filter({!$0.pathComponents.contains(msgs.rimages.rawValue)})
            return f2
        } catch {
            fatalError(msgs.fm.rawValue + msgs.ccRFolder.rawValue + recipesName + " " + msgs.fail.rawValue)
        }
    }
    
    func checkContentsRecipeFolder(recipeFolder: String) -> [URL] {
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(recipesName)
            myDocumentsUrl.appendPathComponent(recipeFolder)
            let contentsRFD = try FileManager.default.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            if zBug { print(msgs.fm.rawValue + msgs.rFolderExists.rawValue, contentsRFD.count)}
            return contentsRFD
        } catch {
            if zBug { print(msgs.fm.rawValue + msgs.ccRFolder.rawValue + recipeFolder + " " + msgs.fail.rawValue)}
            return []
        }
    }
    
    func getBookSectionIdforName(name: String) -> UUID? {
        var myReturn:UUID?
        let shipped = getShippedBookSections()
        let useradded = getUserBookSections()
        if !shipped.filter({$0.name == name}).isEmpty {
            // bs with that exists
            myReturn = shipped.filter({$0.name == name}).first!.id
           
        }
        
        if !useradded.filter({$0.name == name}).isEmpty {
            // bs with that name exists in users
            myReturn = useradded.filter({$0.name == name}).first!.id
        }
        // return nil if neither has the id
        return myReturn
    }
    
    func getUserBookSections() -> [BookSection] {
        var myReturn:[BookSection] = []
        let myDocuDirUrl:URL?
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        } catch {
            // no Documents Dir???
            fatalError()
        }
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
        
        do {
            var urls = try fileManager.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            // get rid of notes and images urls
//            if urls.contains(myReczipesDirUrl.appending(path: msgs.rnotes.rawValue)) {
//                urls.remove(at: urls.firstIndex(of: myReczipesDirUrl.appending(path: msgs.rnotes.rawValue))!)
//            }
//
//            if urls.contains(myReczipesDirUrl.appending(path: msgs.rimages.rawValue)) {
//                urls.remove(at: urls.firstIndex(of: myReczipesDirUrl.appending(path: msgs.rimages.rawValue))!)
//            }
            
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                if aurl.pathComponents.contains(msgs.rnotes.rawValue) || aurl.pathComponents.contains(msgs.rimages.rawValue)  {
                    // skip these folders
                } else {
                    let ajsonfile = fileManager.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                    do {
                        let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                        myReturn.append(aBookSection)
                        if zBug { print(msgs.fm.rawValue + msgs.fuar.rawValue)}
                    } catch  {
                        // not a json file
                        fatalError("This directory has illegal files")
                    }
                }
            }
        } catch  {
            // no contents
            
        }
        if myReturn.isEmpty {
            if zBug { print(msgs.fm.rawValue + msgs.nur.rawValue)}
        } else {
            if zBug { print(msgs.fm.rawValue + msgs.fuar.rawValue)}
        }
        return myReturn
    }
    
    func getShippedBookSections() -> [BookSection] {
        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + msgs.json.rawValue).sorted(by: {$0.name < $1.name})
        return bookSections
    }

    func getRecipesInShippedBookSection(bookSectionUUID: UUID) -> [SectionItem] {
        let bss = self.getShippedBookSections().filter({$0.id == bookSectionUUID})
        return bss.first?.items ?? [SectionItem]()
    }
    
    func getRecipesInUserBookSection(bookSectionUUID: UUID) -> [SectionItem] {
        let bss = self.getUserBookSections().filter({$0.id == bookSectionUUID})
        return bss.first?.items ?? [SectionItem]()
    }
    
    func getShippedNotes() -> [Note] {
        let notes:[Note] = Bundle.main.decode([Note].self, from: msgs.notesshipd.rawValue + msgs.json.rawValue).sorted(by: {$0.note < $1.note})
        return notes
    }
    
    func getShippedImages() -> [ImageSaved] {
        let images:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: msgs.imagesshipd.rawValue + msgs.json.rawValue).sorted(by: {$0.recipeuuid < $1.recipeuuid})
        return images
    }
    
    func getUserNotes() -> [Note] {
        var myReturn:[Note] = []
        let myDocuDirUrl:URL?
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        } catch {
            // no Documents Dir???
            fatalError()
        }
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
        let myNotesDirURL = myReczipesDirUrl.appending(path: msgs.rnotes.rawValue)
        
        do {
            let urls = try fileManager.contentsOfDirectory(at: myNotesDirURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            let myNotesDirURLStr = myNotesDirURL.absoluteString
            for aurl in urls {
                let ajsonfile = fileManager.contents(atPath: myNotesDirURLStr.appending(aurl.absoluteString))!
                do {
                    let aNote = try decoder.decode(Note.self, from: ajsonfile)
                    myReturn.append(aNote)
                    if zBug { print(msgs.fm.rawValue + msgs.fanote.rawValue)}
                } catch  {
                    // not a json file
                    fatalError("This notes directory has illegal files")
                }
            }
        } catch  {
            // no contents
            
        }
        if myReturn.isEmpty {
            if zBug { print(msgs.fm.rawValue + msgs.nunotes.rawValue)}
        }
        return myReturn
    }
    
    func getUserImages() -> [ImageSaved] {
        var myReturn:[ImageSaved] = []
        let myDocuDirUrl:URL?
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        } catch {
            // no Documents Dir???
            fatalError()
        }
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
        let myImagesDirURL = myReczipesDirUrl.appending(path: msgs.rimages.rawValue)
        
        do {
            let urls = try fileManager.contentsOfDirectory(at: myImagesDirURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            let myImagesDirURLStr = myImagesDirURL.absoluteString
            for aurl in urls {
                let ajsonfile = fileManager.contents(atPath: myImagesDirURLStr.appending(aurl.absoluteString))!
                do {
                    let anImage = try decoder.decode(ImageSaved.self, from: ajsonfile)
                    myReturn.append(anImage)
                    if zBug { print(msgs.fm.rawValue + msgs.faimage.rawValue)}
                } catch  {
                    // not a json file
                    fatalError("This notes directory has illegal files")
                }
            }
        } catch  {
            // no contents
            
        }
        if myReturn.isEmpty {
            if zBug { print(msgs.fm.rawValue + msgs.nuimages.rawValue)}
        }
        return myReturn
    }
    
    func getUserBookSectionWithUUID(bookSectionUUID: UUID) -> BookSection? {
        var myReturn:BookSection?
        let bss = self.getUserBookSections().filter({$0.id == bookSectionUUID})
        myReturn = bss.first
        return myReturn
    }
    
    func getShippedBookSectionWithUUID(bookSectionUUID: UUID) -> BookSection? {
        var myReturn:BookSection?
        let bss = self.getShippedBookSections().filter({$0.id == bookSectionUUID})
        myReturn = bss.first
        return myReturn
    }
    
    
    func addNewBookSection(bookSection: BookSection) -> Bool {
        var myReturn: Bool = false
        return myReturn
    }
    
    func AddRecipeToBookSection(recipe: SectionItem, bookSectionUUID: UUID) -> Bool {
        var myReturn:Bool = false
        let myDocuDirUrl:URL?
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        } catch {
            // no Documents Dir???
            fatalError()
        }
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
        
        if (getUserBookSectionWithUUID(bookSectionUUID: bookSectionUUID) != nil) {
            // exists
            do {
                let urls = try fileManager.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                for aurl in urls {
                    let ajsonfile = fileManager.contents(atPath: myReczipesDirUrl.absoluteString.appending(aurl.absoluteString))!
                    do {
                        let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                        if aBookSection.id == bookSectionUUID {
                            // found it, items are SectionItems
                            var newItemsArray = aBookSection.items
                            newItemsArray.append(recipe)
                            let newBookSection = BookSection(id: bookSectionUUID, name: aBookSection.name, items: newItemsArray)
                            // now save it to user recipes
                            // first encode
                            do {
                                let encodedJSON = try encoder.encode(newBookSection)
                                // now write out
                                do {
                                    try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBookSection.name + msgs.json.rawValue))
                                    myReturn = true
                                    if zBug { print(msgs.fm.rawValue + msgs.wrjson.rawValue)}
                                } catch  {
                                    fatalError("Cannot write to user recipes folder")
                                }
                            } catch  {
                                fatalError("Cannot encode booksection to json")
                            }
                            
                        }

                    } catch  {
                        // not a json file
                        fatalError("This is not a json file")
                    }
                }
            } catch  {
                fatalError("Can't read contents of users recipes dir")
            }
        } else {
            // does not exist
            // create bookSection and add recipe
            // user the uuid of shipped booksections (if such a uuid exist in shipped) to create this booksection in the user section
            if (getShippedBookSectionWithUUID(bookSectionUUID: bookSectionUUID) != nil) {
                // a booksection with that UUID exists
                let bs = getShippedBookSectionWithUUID(bookSectionUUID: bookSectionUUID)!
                let id:UUID = bs.id
                let name:String = bs.name
                let newBookSection = BookSection(id: id, name:  name, items: [recipe])
                do {
                    let encodedJSON = try encoder.encode(newBookSection)
                    // now write out
                    do {
                        try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBookSection.name + msgs.json.rawValue))
                        myReturn = true
                        if zBug { print(msgs.fm.rawValue + msgs.wrjson.rawValue)}
                    } catch  {
                        fatalError("Cannot write to user recipes folder")
                    }
                } catch  {
                    fatalError("Cannot encode booksection to json")
                }
            } else {
                // shipped names does not contain this id
                // why user specified this id?
                fatalError("Invalid UUID with recipe")
            }
        }
        return myReturn
    }
    
    func removeRecipeFromBookSection(recipe: SectionItem, bookSectionUUID:UUID) {
        // will fail silently if booksection or recipe does not exist in booksection
        if getUserBookSections().filter({$0.id == bookSectionUUID}).first != nil {
            // booksection with id exists
            
            let myDocuDirUrl:URL?
            do {
                myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false)
            } catch {
                // no Documents Dir???
                fatalError()
            }
            let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
            let bs = getUserBookSections().filter({$0.id == bookSectionUUID}).first!
            var newItemsArray:[SectionItem] = bs.items
            if newItemsArray.firstIndex(of: recipe) != nil {
                newItemsArray.remove(at: newItemsArray.firstIndex(of: recipe)!)
                let newBookSection = BookSection(id: bs.id, name:  bs.name, items: newItemsArray)
                do {
                    let encodedJSON = try encoder.encode(newBookSection)
                    // now write out
                    do {
                        try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBookSection.name + msgs.json.rawValue))
                        if zBug { print(msgs.fm.rawValue + msgs.wrjson.rawValue)}
                    } catch  {
                        fatalError("Cannot write to user recipes folder")
                    }
                } catch  {
                    fatalError("Cannot encode booksection to json")
                }
            } else {
                // nothing to do recipe does not exist
            }
            
            
        } else {
            // nothing to do book section does nto exist
        }
    }
    
    func moveRecipeFromOneBookSectionToOther(recipe: SectionItem, originalBookSectionName: String, newBookSectionName: String) {
        if getUserBookSections().filter({$0.name == newBookSectionName}).first != nil {
            // check if the two booksections are identical
            if originalBookSectionName != newBookSectionName {
                self.removeRecipeFromBookSection(recipe: recipe, bookSectionUUID: getUserBookSections().filter({$0.name == originalBookSectionName}).first!.id)
                let result = self.AddRecipeToBookSection(recipe: recipe, bookSectionUUID: getUserBookSections().filter({$0.name == newBookSectionName}).first!.id)
            } else {
                // booksections are identical, no move required
            }
        } else {
            // BookSection does not exist
        }
    }
    
    func addRecipeImage(image: ImageSaved) -> Bool {
        var myReturn:Bool = false
        let myDocuDirUrl:URL?
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        } catch {
            // no Documents Dir???
            fatalError()
        }
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
        let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
        do {
            let encodedJSON = try encoder.encode(image)
            // now write out
            do {
                try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(image.recipeuuid.description + msgs.json.rawValue))
                myReturn = true
                if zBug { print(msgs.fm.rawValue + msgs.wrjson.rawValue)}
            } catch  {
                fatalError("Cannot write to user RecipeImages folder")
            }
        } catch  {
            fatalError("Cannot encode booksection to json")
        }
        return myReturn
    }
    
    func addRecipeNote(note: Note) -> Bool {
        var myReturn = false
        let myDocuDirUrl:URL?
        do {
            myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        } catch {
            // no Documents Dir???
            fatalError()
        }
        let myReczipesDirUrl:URL = myDocuDirUrl!.appending(path: msgs.recz.rawValue)
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
        do {
            let encodedJSON = try encoder.encode(note)
            // now write out
            do {
                try encodedJSON.write(to: myNotesDirUrl.appendingPathComponent(note.recipeuuid.description + msgs.json.rawValue))
                myReturn = true
                if zBug { print(msgs.fm.rawValue + msgs.wrjson.rawValue)}
            } catch  {
                fatalError("Cannot write to user RecipeNotes folder")
            }
        } catch  {
            fatalError("Cannot encode booksection to json")
        }
        return myReturn
    }
}

