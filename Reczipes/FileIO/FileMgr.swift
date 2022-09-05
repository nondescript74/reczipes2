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
    // MARK: - Published
    @Published var docsDirContents: [URL] = []
    @Published var docsReczipesDirContents: [URL] = []
    @Published var shippedBookSectionsDirContents: [BookSection] = []
    @Published var userBookSectionsDirContents: [BookSection] = []
    @Published var shippedRecipes: [SectionItem] = []
    @Published var userRecipes: [SectionItem] = []
    @Published var shippedRecipesNotesFolderContents: [Note] = []
    @Published var userRecipesNotesFolderContents: [Note] = []
    @Published var shippedRecipesImagesFolderContents: [ImageSaved] = []
    @Published var userRecipesImagesFolderContents: [ImageSaved] = []
    // MARK: - Initializer
    override init() {
        
        super.init()
        
        createRecipesFolder()
        getDocuDirContents()
        getShippedBookSections()
        getUserBookSections()
        getShippedNotes()
        getUserNotes()
        getShippedImages()
        getUserImages()
        
    }
    
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
        case rNotesFolderExists = "RecipeNotes Folder already exists "
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
        case notejson = "Successfully wrote note"
        case imgjson = "Successfully wrote image"
        case fail = "Failed"
        case succes = "Success"
        case ccRFolder = "checkContentsReczFolder"
    }
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    
    // MARK: - Methods
    private func createRecipesFolder() {
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
        if !self.fileManager.fileExists(atPath: myReczipesDirUrl.absoluteString, isDirectory: &isDirectory) {
            do {
                try self.fileManager.createDirectory(at: myReczipesDirUrl, withIntermediateDirectories: true)
                if zBug { print(msgs.fm.rawValue + msgs.rFolderExists.rawValue)}
            } catch {
                fatalError("Can't create reczipes directory")
            }
            
        } else {
            // exists
            if zBug { print(msgs.fm.rawValue + msgs.rFolderExists.rawValue)}
        }
        
        
        let myReczNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
//        if !self.fileManager.fileExists(atPath: myReczNotesDirUrl.absoluteString, isDirectory: &isDirectory) {
            do {
                try self.fileManager.createDirectory(at: myReczNotesDirUrl, withIntermediateDirectories: true)
                if zBug { print(msgs.fm.rawValue + msgs.rNotesFolderCreated.rawValue)}
            } catch {
                fatalError("Can't create RecipeNotes directory")
            }
            
//        } else {
            // exists
//            if zBug { print(msgs.fm.rawValue + msgs.rNotesFolderExists.rawValue)}
//        }

        let myReczImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
//        if !self.fileManager.fileExists(atPath: myReczImagesDirUrl.absoluteString, isDirectory: &isDirectory) {
            do {
                try self.fileManager.createDirectory(at: myReczImagesDirUrl, withIntermediateDirectories: true)
                if zBug { print(msgs.fm.rawValue + msgs.rImagesFolderCreated.rawValue)}
            } catch {
                fatalError("Can't create RecipeNotes directory")
            }
//            
//        } else {
//            // exists
//            if zBug { print(msgs.fm.rawValue + msgs.rImagesFolderExists.rawValue)}
//        }
    }
    
    private func createHomeDirPathUrl() -> URL {
        do {
            let myDocuDirUrl = try fileManager.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
            return myDocuDirUrl
        } catch {
            fatalError(msgs.fm.rawValue + msgs.fail.rawValue)
        }
    }
    
    func getDocuDirContents() {
        let myDocuDirUrl = createHomeDirPathUrl()
        DispatchQueue.main.async { [self] in
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: myDocuDirUrl, includingPropertiesForKeys: nil)
                if zBug { print(msgs.fm.rawValue + msgs.docudir.rawValue + fileURLs.debugDescription, fileURLs.count.description)}
                self.docsDirContents = fileURLs
            } catch {
                fatalError(msgs.fm.rawValue + msgs.fail.rawValue)
            }
        }
    }
    
    func getContentsReczipesFolder() {
        let myDocuDirUrl = createHomeDirPathUrl()
        DispatchQueue.main.async { [self] in
            do {
                var myDocumentsUrl = myDocuDirUrl
                myDocumentsUrl.appendPathComponent(recipesName)
                let contentsRFD = try FileManager.default.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                if zBug { print(msgs.fm.rawValue + msgs.rFolderExists.rawValue, contentsRFD.count)}
                let f1 = contentsRFD.filter({!$0.pathComponents.contains(msgs.rnotes.rawValue)})
                let f2 = f1.filter({!$0.pathComponents.contains(msgs.rimages.rawValue)})
                self.docsReczipesDirContents = f2
            } catch {
                fatalError(msgs.fm.rawValue + msgs.ccRFolder.rawValue + recipesName + " " + msgs.fail.rawValue)
            }
        }
    }
    
    func getBookSectionIdforName(name: String) -> UUID? {
        var myReturn:UUID?
        let shipped = shippedBookSectionsDirContents
        let useradded = userBookSectionsDirContents
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
    
    func getUserBookSections() {
        userBookSectionsDirContents.removeAll()
        DispatchQueue.main.async { [self] in
            do {
                let myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
                
                let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
                
                do {
                    let urls = try fileManager.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                    let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
                    for aurl in urls {
                        if aurl.pathComponents.contains(msgs.rnotes.rawValue) || aurl.pathComponents.contains(msgs.rimages.rawValue)  {
                            // skip these folders
                        } else {
                            let ajsonfile = fileManager.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                            do {
                                let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                                userBookSectionsDirContents.append(aBookSection)
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
                
            } catch {
                // no Documents Dir???
                fatalError()
            }
        }
    }
    
    func getShippedBookSections() {
        DispatchQueue.main.async { [self] in
            let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + msgs.json.rawValue).sorted(by: {$0.name < $1.name})
            shippedBookSectionsDirContents = bookSections
        }
        
    }
    
    func getRecipesInShippedBookSection(bookSectionUUID: UUID) -> [SectionItem] {
        self.getShippedBookSections()
        var filteredShippedRecipes :[SectionItem] = []
        
        let bss = shippedBookSectionsDirContents.filter({$0.id == bookSectionUUID})
        filteredShippedRecipes = bss.first?.items ?? [SectionItem]()
        
        return filteredShippedRecipes
    }
    
    func getRecipesInUserBookSection(bookSectionUUID: UUID) -> [SectionItem] {
        self.getUserBookSections()
        var filteredUserRecipes: [SectionItem] = []
        let bss = userBookSectionsDirContents.filter({$0.id == bookSectionUUID})
        filteredUserRecipes = bss.first?.items ?? [SectionItem]()
        
        return filteredUserRecipes
        
    }
    
    func getShippedNotes() {
        //        shippedRecipesNotesFolderContents.removeAll()
        DispatchQueue.main.async { [self] in
            let notes:[Note] = Bundle.main.decode([Note].self, from: msgs.notesshipd.rawValue + msgs.json.rawValue).sorted(by: {$0.note < $1.note})
            shippedRecipesNotesFolderContents = notes
        }
    }
    
    func getShippedImages() {
        //        shippedRecipesImagesFolderContents.removeAll()
        //        DispatchQueue.main.async { [self] in
        //            let images:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: msgs.imagesshipd.rawValue + msgs.json.rawValue).sorted(by: {$0.recipeuuid < $1.recipeuuid})
        //            shippedRecipesImagesFolderContents = images
        //        }
    }
    
    func getUserNotes() {
        //        userRecipesNotesFolderContents.removeAll()
        DispatchQueue.main.async { [self] in
            do {
                let myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
                
                let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
                let myNotesDirURL = myReczipesDirUrl.appending(path: msgs.rnotes.rawValue)
                
                do {
                    let urls = try fileManager.contentsOfDirectory(at: myNotesDirURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                    if urls.isEmpty {
                        // nothing to do
                        if zBug { print(msgs.fm.rawValue + msgs.nunotes.rawValue)}
                    } else {
                        userRecipesNotesFolderContents = []
                        for aurl in urls {
                            do {
                                let data = try Data(contentsOf: aurl)
                                let aNote = try decoder.decode(Note.self, from: data)
                                userRecipesNotesFolderContents.append(aNote)
                                if zBug { print(msgs.fm.rawValue + msgs.fanote.rawValue)}
                            } catch  {
                                // not a json file
                                fatalError("This notes directory has illegal files")
                            }
                        }
                    }
                    
                } catch  {
                    // no contents
                }
            } catch {
                // no Documents Dir???
                fatalError()
            }
        }
    }
    
    func getUserImages() {
        //        userRecipesImagesFolderContents.removeAll()
        DispatchQueue.main.async { [self] in
            do {
                let myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
                
                let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
                let myImagesDirURL = myReczipesDirUrl.appending(path: msgs.rimages.rawValue)
                
                
                do {
                    let urls = try fileManager.contentsOfDirectory(at: myImagesDirURL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                    if urls.isEmpty {
                        if zBug { print(msgs.fm.rawValue + msgs.nuimages.rawValue)}
                    } else {
                        for aurl in urls {
                            do {
                                let data = try Data(contentsOf: aurl)
                                let anImage = try decoder.decode(ImageSaved.self, from: data)
                                userRecipesImagesFolderContents.append(anImage)
                                if zBug { print(msgs.fm.rawValue + msgs.faimage.rawValue)}
                                
                            } catch  {
                                // not a json file
                                fatalError("This notes directory has illegal files")
                            }
                        }
                    }
                } catch  {
                    // no contents
                }
            } catch {
                // no Documents Dir???
                fatalError()
            }
        }
    }
    
    func getUserBookSectionWithUUID(bookSectionUUID: UUID) -> BookSection? {
        var myReturn:BookSection?
        let bss = userBookSectionsDirContents.filter({$0.id == bookSectionUUID})
        myReturn = bss.first
        return myReturn
    }
    
    func getShippedBookSectionWithUUID(bookSectionUUID: UUID) -> BookSection? {
        var myReturn:BookSection?
        let bss = shippedBookSectionsDirContents.filter({$0.id == bookSectionUUID})
        myReturn = bss.first
        return myReturn
    }
    
    func getBookSectionIdForName(name: String) -> UUID? {
        var myReturn: UUID?
        let bss = shippedBookSectionsDirContents.filter({$0.name == name})
        if !bss.isEmpty {
            myReturn = bss.first!.id
        } else {
            
        }
        return myReturn
    }
    
    
    func AddRecipeToBookSection(recipe: SectionItem, bookSectionUUID: UUID) {
        DispatchQueue.main.async { [self] in
            do {
                let myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
                
                
                let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
                
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
                    var id:UUID
                    let name:String
                    if (getShippedBookSectionWithUUID(bookSectionUUID: bookSectionUUID) != nil) {
                        // a booksection with that UUID exists
                        let bs = getShippedBookSectionWithUUID(bookSectionUUID: bookSectionUUID)!
                        id = bs.id
                        name = bs.name
                    } else {
                        // no such ID
                        id = bookSectionUUID
                        name = "Z"
                    }
                    
                    let newBookSection = BookSection(id: id, name:  name, items: [recipe])
                    do {
                        let encodedJSON = try encoder.encode(newBookSection)
                        // now write out
                        do {
                            try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBookSection.name + msgs.json.rawValue))
                            if zBug { print(msgs.fm.rawValue + msgs.wrjson.rawValue)}
                        } catch  {
                            fatalError("Cannot write to user booksections folder")
                        }
                    } catch  {
                        fatalError("Cannot encode booksection to json")
                    }
                }
            } catch {
                // no Documents Dir???
                fatalError()
            }
        }
    }
    
    func removeRecipeFromBookSection(recipe: SectionItem, bookSectionUUID:UUID) {
        // will fail silently if booksection or recipe does not exist in booksection
        if userBookSectionsDirContents.filter({$0.id == bookSectionUUID}).first != nil {
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
            let bs = userBookSectionsDirContents.filter({$0.id == bookSectionUUID}).first!
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
        if userBookSectionsDirContents.filter({$0.name == newBookSectionName}).first != nil {
            // check if the two booksections are identical
            if originalBookSectionName != newBookSectionName {
                self.removeRecipeFromBookSection(recipe: recipe, bookSectionUUID: userBookSectionsDirContents.filter({$0.name == originalBookSectionName}).first!.id)
                self.AddRecipeToBookSection(recipe: recipe, bookSectionUUID: userBookSectionsDirContents.filter({$0.name == newBookSectionName}).first!.id)
            } else {
                // booksections are identical, no move required
            }
        } else {
            // BookSection does not exist
        }
    }
    
    func addRecipeImage(image: ImageSaved) {
        
        DispatchQueue.main.async { [self] in
            do {
                let myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
                
                let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
                let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
                do {
                    let encodedJSON = try encoder.encode(image)
                    // now write out
                    do {
                        try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(image.recipeuuid.description + msgs.json.rawValue))
                        if zBug { print(msgs.fm.rawValue + msgs.imgjson.rawValue)}
                    } catch  {
                        fatalError("Cannot write to user RecipeImages folder")
                    }
                } catch  {
                    fatalError("Cannot encode booksection to json")
                }
            } catch {
                // no Documents Dir???
                fatalError()
            }
        }
    }
    
    func addRecipeNote(note: Note) {
        
        DispatchQueue.main.async { [self] in
            do {
                let myDocuDirUrl = try self.fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
                
                let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
                let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
                
                
                do {
                    let encodedJSON = try encoder.encode(note)
                    // now write out
                    do {
                        try encodedJSON.write(to: myNotesDirUrl.appendingPathComponent(note.recipeuuid.description + msgs.json.rawValue))
                        if zBug { print(msgs.fm.rawValue + msgs.notejson.rawValue)}
                        let result = try contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [])
                        if zBug { print(msgs.fm.rawValue + "Contents count " + "\(result.count)")}
                    } catch  {
                        fatalError("Cannot write to user RecipeNotes folder")
                    }
                } catch  {
                    fatalError("Cannot encode booksection to json")
                }
                
            } catch {
                // no Documents Dir???
                fatalError()
            }
        }
    }
}

