//
//  RecipeDetailView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI
import MessageUI

struct RecipeDetailView: View {
    //MARK: - Environment
    @EnvironmentObject var order: OrderingList
    // MARK: - Local debug flag
    fileprivate var zBug:Bool = false
    
    // MARK: - Initializer
    init(imageString: String, sectionItem: SectionItem, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
        anImage.getImageFromUrl(urlString: imageString, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
    }
    
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Properties
    var item: SectionItem
    var cuisine: String = ""
    fileprivate enum msgs: String {
        case recipeDetailView, RDV = "RecipeDetailView: "
        case nothing = "Nothing"
        case sectIsOther = "Section Name is set to Other"
        case addImage = "Add Images To Recipe"
        case addNote = "Add Note To Recipe"
        case plusNote = "+ Note"
        case plusImage = "+ Image"
        case exists = "Recipe already saved"
        case recipeImages = "RecipeImagesFolder has Images"
        case recipeNotes = "RecipeNotesFolder has Notes"
        case recipeImagesNot = "RecipeImagesFolder has no Images"
        case recipeNotesNot = "RecipeNotesFolder has no Notes"
        case recz = "Reczipes"
        case json = ".json"
        case wrjson = "Successfully wrote booksection"
        case notejson = "Successfully wrote note"
        case imgjson = "Successfully wrote image"
        
    }
    
    fileprivate enum namez: String {
        case notes = "Notes"
        case json = ".json"
        case images = "Images"
    }
    
    fileprivate enum labelz: String {
        case order = "Order"
        case add = "Add"
        case save = "Save"
        case move = "Move"
        case recipe = "This"
        case ingredients = "Ingred"
        case remove = "Remove"
        case trash = "trash"
        case show = "Show"
        case notes = "Notes"
        case images = "Images"
        case send = "Send"
        case mail = "📩"
        case nbartitle = "Recipe Details"
        
    }
    
    fileprivate enum imagez: String {
        case snp = "square.and.pencil"
        case pencil = "pencil"
        case gc = "greetingcard"
        case mail = "envelope"
        case add = "plus"
        
    }
    // MARK: - State
    @State fileprivate var showingNotes = false
    @State fileprivate var showingImages = false
    @State fileprivate var addingImage = false
    @State fileprivate var addingNote = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State fileprivate var recipeSaved = false
    @State fileprivate var showingMoveView = false
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    private func getDocuDirUrl() -> URL {
        var myReturn:URL
        do {
            let myDocuDirUrl = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            myReturn = myDocuDirUrl
        } catch {
            fatalError()
        }
        return myReturn
    }
    
    fileprivate func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        let myNotesDirUrlStr = myNotesDirUrl.absoluteString
        
        do {
            let result = try FileManager.default.contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [])
            if zBug { print(msgs.RDV.rawValue + "Contents count " + "\(result.count)")}
            for aUrl in result {
                let data = FileManager.default.contents(atPath: myNotesDirUrlStr.appending(aUrl.absoluteString))!
                let decodedJSON = try decoder.decode(Note.self, from: data)
                myNotesConstructed.append(decodedJSON)
            }
            
        } catch  {
            fatalError("Cannot read or decode from notes")
        }
        
        let shippedNotes:[Note] = Bundle.main.decode([Note].self, from: namez.notes.rawValue + msgs.json.rawValue).sorted(by: {$0.recipeuuid < $1.recipeuuid}).filter({$0.recipeuuid == item.id.uuidString})
        if shippedNotes.isEmpty  {
            
        } else {
            myNotesConstructed.append(contentsOf: shippedNotes)
        }
        
        myNotesConstructed = myNotesConstructed.filter({$0.recipeuuid == self.item.id.uuidString})
        print(msgs.RDV.rawValue + msgs.recipeNotes.rawValue + "\(myNotesConstructed.count)")
        return myNotesConstructed
    }
    fileprivate func hasNotes() -> Bool {
        let userNotes = constructNotesIfAvailable()
        if userNotes.isEmpty {
            return false
        }
        return true
        
    }
    
    fileprivate func constructImagesIfAvailable() -> Array<ImageSaved> {
        var myImagesConstructed:Array<ImageSaved> = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        let myImagesDirUrlStr = myImagesDirUrl.absoluteString
        
        do {
            let result = try FileManager.default.contentsOfDirectory(at: myImagesDirUrl, includingPropertiesForKeys: [])
            if zBug { print(msgs.RDV.rawValue + "Contents count " + "\(result.count)")}
            for aUrl in result {
                let data = FileManager.default.contents(atPath: myImagesDirUrlStr.appending(aUrl.absoluteString))!
                let decodedJSON = try decoder.decode(ImageSaved.self, from: data)
                myImagesConstructed.append(decodedJSON)
            }
            
        } catch  {
            fatalError("Cannot read or decode from notes")
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: namez.images.rawValue + msgs.json.rawValue).sorted(by: {$0.recipeuuid < $1.recipeuuid}).filter({$0.recipeuuid == item.id.uuidString})
        if shippedImages.isEmpty  {
            
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
        }
        
        myImagesConstructed = myImagesConstructed.filter({$0.recipeuuid == self.item.id.uuidString})
        print(msgs.RDV.rawValue + msgs.recipeImages.rawValue + "\(myImagesConstructed.count)")
        return myImagesConstructed
    }
    
    fileprivate func hasImages() -> Bool {
        let userImages = constructImagesIfAvailable()
        if userImages.isEmpty {
            return false
        }
        return true
    }
    
    func getBookSectionIDForName(name: String) -> UUID? {
        var myReturn:UUID?
//        let escape: Character = "\""
        // special characters are escaped
        if !getBookSectionNames().contains(name) {
            // bs with that exists
            myReturn = getBookSections().filter({$0.name == name}).first!.id
        }
        return myReturn
    }
    
    func getBookSections() -> [BookSection] {
        var myReturn: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).filter({$0.lastPathComponent.contains(msgs.json.rawValue)})
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrl.absoluteString.appending(aurl.absoluteString))!
                let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                myReturn.append(aBookSection)
            }
            let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: "recipesShipped.json").sorted(by: {$0.name < $1.name})
            for aBS in bookSections {
                myReturn.append(aBS)
            }
        } catch  {
            fatalError("Can't read contents of users recipes dir")
        }
        
        return myReturn
    }
    
    func getBookSectionWithUUID(bookSectionUUID: UUID) -> BookSection? {
        var myReturn:BookSection?
        let bs = getBookSections().filter({$0.id == bookSectionUUID})
        myReturn = bs.first
        return myReturn
    }
    
    
    func addRecipeToBookSection(recipe: SectionItem, bookSectionUUID: UUID) {
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        if (getBookSectionWithUUID(bookSectionUUID: bookSectionUUID) != nil) {
            // exists
            do {
                // first try in user recipes
                var bookSections = getBookSections()
                for aBookSection in bookSections {
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
                                if zBug { print(msgs.RDV.rawValue + msgs.wrjson.rawValue)}
                                
                            } catch  {
                                fatalError("Cannot write to user recipes folder")
                            }
                        } catch  {
                            fatalError("Cannot encode booksection to json")
                        }
                    }
                }
            }

        } else {
            // does not exist
            // create bookSection and add recipe
            // user the uuid of shipped booksections (if such a uuid exist in shipped) to create this booksection in the user section
            var id:UUID
            let name:String
            if (getBookSectionWithUUID(bookSectionUUID: bookSectionUUID) != nil) {
                // a booksection with that UUID exists
                let bs = getBookSectionWithUUID(bookSectionUUID: bookSectionUUID)!
                id = bs.id
                name = bs.name
            } else {
                // no such ID
                id = bookSectionUUID
                name = "Z" + Date().description
            }
            
            let newBookSection = BookSection(id: id, name:  name, items: [recipe])
            do {
                let encodedJSON = try encoder.encode(newBookSection)
                // now write out
                do {
                    try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBookSection.name + msgs.json.rawValue))
                    if zBug { print(msgs.RDV.rawValue + msgs.wrjson.rawValue)}
                } catch  {
                    fatalError("Cannot write to user booksections folder")
                }
            } catch  {
                fatalError("Cannot encode booksection to json")
            }
        }
    }
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    if UIImage(named: item.mainImage) == nil {
                        anImage.anImage?
                            .resizable()
                            .padding(.all, 5)
                    } else {
                        Image(item.mainImage)
                            .resizable()
                            .padding(.all, 5)
                    }
                    
                    Text("Photo: \(item.photocredit)")
                        .background(Color.gray)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding()
                }
                
                HStack {
                    Button(action: {
                        // What to perform
                        addRecipeToBookSection(recipe: item, bookSectionUUID: getBookSectionIDForName(name: cuisine)!)
                        recipeSaved = true
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.save.rawValue, someTextBottom: labelz.recipe.rawValue, someImage: imagez.add.rawValue, reversed: false)
                    }.disabled(cuisine.isEmpty)
                    Button(action: {
                        // What to perform
                        self.showingMoveView.toggle()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.move.rawValue, someTextBottom: labelz.recipe.rawValue, someImage: imagez.add.rawValue, reversed: false)
                    }.disabled(cuisine.isEmpty)
                    Button(action: {
                        // What to perform
                        self.order.add(item: self.item)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.order.rawValue, someTextBottom: labelz.ingredients.rawValue, someImage: imagez.snp.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        self.order.remove(item: self.item)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.remove.rawValue, someTextBottom: labelz.ingredients.rawValue, someImage: labelz.trash.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        self.showingNotes.toggle()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.notes.rawValue, someImage: imagez.pencil.rawValue, reversed: true)
                    }
                    Button(action: {
                        // What to perform
                        self.showingImages.toggle()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.images.rawValue, someImage: imagez.gc.rawValue, reversed: true)
                    }
                    
                    Button(action: {
                        // What to perform
                        self.isShowingMailView.toggle()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.send.rawValue, someTextBottom: labelz.mail.rawValue, someImage: imagez.mail.rawValue, reversed: true)
                    }.disabled(!MFMailComposeViewController.canSendMail())
                    
                    
                }
                Divider()
                if showingNotes == true && hasNotes() {
                    NotesView(recipeuuid: self.item.id.description)
                }
                Divider()
                if showingImages == true && hasImages() {
                    ImagesView(recipeuuid: self.item.id.description)
                }
                Divider()
                if showingMoveView == true && cuisine != "" {
                    MoveRecipeView(movingRecipe: self.item, moveFromBookSection: self.cuisine)
                }
                Divider()
                VStack {
                    SafariView(url: URL(string: item.url)!)
                }
            }
            
            .sheet(isPresented: $addingImage) {
                AddImageAndNoteView()
            }
            .sheet(isPresented: $addingNote) {
                AddImageAndNoteView()
            }
            .sheet(isPresented: $isShowingMailView) {
                //                MailView(result: self.$result, sectItem: self.item)
            }
            .alert(isPresented: $recipeSaved)   {
                return Alert(title: Text("Saving Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle(Text(labelz.nbartitle.rawValue), displayMode: .inline)
        }
    }
}


struct RecipeDetailView_Previews: PreviewProvider {
    // MARK: - Environment
    static let order = OrderingList()
    // MARK: - View Process
    static var previews: some View {
        NavigationView {
            RecipeDetailView(imageString: defaultImageUrl, sectionItem: SectionItem.example3, cuisine: getBookSectionNames().last!)
                .environmentObject(order)
        }
    }
}

