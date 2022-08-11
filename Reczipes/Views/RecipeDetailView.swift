//
//  RecipeDetailView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI
import MessageUI

struct RecipeDetailView: View {
#if DEBUG
    // MARK: - Local debug flag
    fileprivate var zBug: Bool = true
#endif
    // MARK: - Initializer
    init(imageString: String, sectionItem: SectionItem) {
        self.item = sectionItem
        self.cuisine = ""
        anImage.getImageFromUrl(urlString: imageString, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        
    }
    
    init(imageString: String, sectionItem: SectionItem, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
        anImage.getImageFromUrl(urlString: imageString, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
    }
    
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Properties
    var item: SectionItem
    let fileIO = FileIO()
    var cuisine: String = ""
    fileprivate enum msgs: String {
        case recipeDetailView = "RecipeDetailView: "
        case nothing = "Nothing"
        case addImage = "Add Images To Recipe"
        case addNote = "Add Note To Recipe"
        case plusNote = "+ Note"
        case plusImage = "+ Image"
        case recipeImages = "RecipeImagesFolder has Images"
        case recipeNotes = "RecipeNotesFolder has Notes"
        case recipeImagesNot = "RecipeImagesFolder has no Images"
        case recipeNotesNot = "RecipeNotesFolder has no Notes"
    }
    
    fileprivate enum namez: String {
        case notes = "Notes"
        case json = ".json"
    }
    
    fileprivate enum labelz: String {
        case order = "Order"
        case add = "Add"
        case save = "Save"
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
    //MARK: - Environment
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - State
    @State fileprivate var showingNotes = false
    @State fileprivate var showingImages = false
    @State fileprivate var addingImage = false
    @State fileprivate var addingNote = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State fileprivate var recipeSaved = false
    // MARK: - Methods
    fileprivate func hasNotes() -> Bool {
        let myNotesUrls = fileIO.readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeNotesFolderName)
        let zmyNotes = myNotesUrls.filter {$0.description.contains( item.id.description)}
        let nmyNotes = Bundle.main.decode([Note].self, from: namez.notes.rawValue + namez.json.rawValue)  // array of Note
        let savedNotes = nmyNotes.filter { $0.recipeuuid.description == item.id.description }
        
        return !zmyNotes.isEmpty || !savedNotes.isEmpty
    }
    
    fileprivate func hasImages() -> Bool {
        let myImagesUrls = fileIO.readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeImagesFolderName)
        let zmyImages = myImagesUrls.filter {$0.description.contains( item.id.description)}
        
#if DEBUG
        if zBug {
            if !zmyImages.isEmpty {
                print(msgs.recipeDetailView.rawValue + msgs.recipeImages.rawValue)
            } else {
                print(msgs.recipeDetailView.rawValue + msgs.recipeImagesNot.rawValue)
            }
        }
#endif
        
        return !zmyImages.isEmpty
    }
    
    fileprivate func createBookSection() {
        
        var myUUID = BookSection.example.id
        var myBookSection = BookSection.example
        for asection in addedRecipes.bookSections {
            if asection.name.lowercased() == cuisine.lowercased() {
                myUUID = asection.id
                myBookSection = asection
            }
        }
        addedRecipes.changeBookSection(bookSection: myBookSection,
                                       addingItemsFrom: BookSection(id: myUUID,
                                                                    name: cuisine,
                                                                    items: [item])
        )
        
        self.recipeSaved.toggle()
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
                    //.frame(width: proxy.size.width, height: 100, alignment: .bottomTrailing)
                }
                
                HStack {
                    Button(action: {
                        // What to perform
                        self.createBookSection()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.save.rawValue, someTextBottom: labelz.recipe.rawValue, someImage: imagez.add.rawValue, reversed: false)
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
                
                if showingNotes == true && hasNotes() {
                    NotesView(recipeuuid: self.item.id.description)
                }
                if showingImages == true && hasImages() {
                    ImagesView(recipeuuid: self.item.id.description)
                }
                
                VStack {
                    SafariView(url: URL(string: item.url)!)
                }
                Spacer()
            }
            
            .sheet(isPresented: $addingImage) {
                AddImageToRecipeView2()
            }
            .sheet(isPresented: $addingNote) {
                AddNotesToRecipeView2()
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: self.$result, sectItem: self.item)
            }
            .alert(isPresented: $recipeSaved)   {
                return Alert(title: Text("Saving Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle(Text(labelz.nbartitle.rawValue), displayMode: .inline)
        }
    }
}

#if DEBUG
struct RecipeDetailView_Previews: PreviewProvider {
    // MARK: - Environment
    static let order = OrderingList()
    static let addedRecipes = AddedRecipes()
    // MARK: - View Process
    static var previews: some View {
        NavigationView {
            RecipeDetailView(imageString: defaultImageUrl, sectionItem: SectionItem.example3)
                .environmentObject(order)
        }
    }
}
#endif
