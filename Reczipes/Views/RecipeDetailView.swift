//
//  RecipeDetailView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct RecipeDetailView: View {
    // MARK: - Initializer
    init(imageString: String, sectionItem: SectionItem) {
        self.item = sectionItem
        anImage.getImageFromUrl(urlString: imageString, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
    }
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Properties
    var item: SectionItem
    let fileIO = FileIO()
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
        case ingredients = "Ingred"
    }
    
    fileprivate enum imagez: String {
        case snp = "square.and.pencil"
    }
    //MARK: - Environment
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - State
    @State fileprivate var showingNotes = false
    @State fileprivate var showingImages = false
    @State fileprivate var addingImage = false
    @State fileprivate var addingNote = false
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
        if !zmyImages.isEmpty {
            print(msgs.recipeDetailView.rawValue + msgs.recipeImages.rawValue)
        } else {
            print(msgs.recipeDetailView.rawValue + msgs.recipeImagesNot.rawValue)
        }
        #endif
        
        return !zmyImages.isEmpty
    }

    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Button(action: {
                            // What to perform
                            self.order.add(item: self.item)
                        }) {
                            // How the button looks like
                            RoundButton2View(someTextTop: "Order", someTextBottom: "Ingred", someImage: "square.and.pencil", reversed: false)
                        }
                        Button(action: {
                            // What to perform
                            self.order.remove(item: self.item)
                        }) {
                            // How the button looks like
                            RoundButton2View(someTextTop: "Remove", someTextBottom: "Ingred", someImage: "trash", reversed: false)
                        }
                    }  //.frame(width: proxy.size.width / 3 , height: 100, alignment: .center)
                    
                    
                    ZStack {
                        if UIImage(named: item.mainImage) == nil {
                            anImage.anImage?
                                .resizable()
                                .scaledToFit()
                                .padding(.all, 5)
//                                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                        } else {
                            Image(item.mainImage)
                                .resizable()
                                .scaledToFit()
                                .padding(.all, 5)
//                                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                        }
                        
                        Text("Photo: \(item.photocredit)")
                            .background(Color.black)
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: proxy.size.width / 3, height: 100, alignment: .bottomTrailing)
                    }
                    
                    VStack {
                        Button(action: {
                            // What to perform
                            self.showingNotes.toggle()
                        }) {
                            // How the button looks like
                            RoundButton2View(someTextTop: "Show", someTextBottom: "Notes", someImage: "pencil", reversed: true)
                        }
                        Button(action: {
                            // What to perform
                            self.showingImages.toggle()
                        }) {
                            // How the button looks like
                            RoundButton2View(someTextTop: "Show", someTextBottom: "Images", someImage: "greetingcard", reversed: true)
                        }
                    }  //.frame(width: proxy.size.width / 3, height: 100, alignment: .center)
                    
                }.frame(width: proxy.size.width, height: 200, alignment: .leading)
                
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
            
            .navigationBarTitle(Text("Recipe Details"), displayMode: .inline)

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
