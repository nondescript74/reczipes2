//
//  RecipeDetailView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI
import OSLog

struct RecipeDetailView: View {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "RecipeDetailView")
    //MARK: - Environment
    @Environment(OrderingList.self) private var order
    @Environment(AllUserRecipes.self) private var aur
    @Environment(AllUserImages.self) private var aui
    @Environment(AllUserNotes.self) private var aun
    // MARK: - Initializer
    init(sectionItem: SectionItem3) {
        self.item = sectionItem
        logger.info("init called with sectionItem name: \(sectionItem.name)")
    }
    
    // MARK: - Properties
    fileprivate var item: SectionItem3
    
    fileprivate enum msgs: String {
//        case recipeDetailView, RDV = "RecipeDetailView: "
        case norid = "No RecipeId"
        case ridltz = "RecipeId is negative"
        case ridgnnn = "RecipeId is greater or equal to 9999999"
        case riiv = "RecipeId is valid"
        case ro = "result number of steps obtained is "
        case irid = "invalid recipeid sent in"
        case cnd = "could not decode AnalyzedInstructions from data"
        case nk = "No Api Key"
        case siid = "SectionItem3 Id is: "
    }
    
    fileprivate enum labelz: String {
        case order = "Order"
        case save = "Save"
        case add = "Add"
        case share = "Share"
        case recipe = "This"
        case ingredients = "Ingred"
        case show = "Show"
        case notes = "Notes"
        case images = "Images"
        case instr = "Instr"
        case rec = "Recipe"
        case nbartitle = "Recipe Details"
        
    }
    
    fileprivate enum imagez: String {
        case order = "list.clipboard"
        case book = "book"
        case images = "photo.stack"
        case save = "externaldrive.badge.plus"
        case share, rec = "square.and.arrow.up"
        case instr = "list.bullet.clipboard.fill"
    }
    
    // MARK: - State
    @State fileprivate var showingNotes = false
    @State fileprivate var showingImages = false
    @State fileprivate var addingImage = false
    @State fileprivate var addingNote = false
    @State fileprivate var showShareSheet = false
    @State fileprivate var recipeSaved = false
    @State fileprivate var showingRecipe = false
    @State fileprivate var showingInstructions = false
    
    // MARK: - Methods
    fileprivate func hasNotes() -> Bool {
        var userNotes = aun.notes
        userNotes = userNotes.filter({$0.recipeuuid == item.id})
        if userNotes.isEmpty {
            logger.info("recipe has no notes")
            return false
        }
        logger.info( "recipe has notes")
        return true
    }
    
    fileprivate func hasImages() -> Bool {
        var imageSaveds = aui.images
        imageSaveds = imageSaveds.filter({$0.recipeuuid == item.id})
        if imageSaveds.isEmpty {
            logger.info( "recipe has no images")
            return false
        }
        logger.info( "recipe has images")
        return true
    }
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    ZStack {
                        AsyncImage(url: URL(string: (item.imageUrl ?? SectionItem3.example.imageUrl)!)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                            }  else {
                                ProgressView()
                            }
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
                            self.showingNotes.toggle()
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.notes.rawValue, someImage: imagez.book.rawValue, reversed: !self.hasNotes())
                        }.disabled(!self.hasNotes())
                        Button(action: {
                            // What to perform
                            self.showingImages.toggle()
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.images.rawValue, someImage: imagez.images.rawValue, reversed: !self.hasImages())
                        }.disabled(!self.hasImages())
                        Button(action: {
                            // What to perform
                            self.showingRecipe.toggle()
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.rec.rawValue, reversed: item.url.isEmpty)
                        }.disabled(item.url.isEmpty)
                        Button(action: {
                            // What to perform
                            
                            self.showingInstructions.toggle()
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.instr.rawValue, someImage: imagez.instr.rawValue, reversed: item.url.isEmpty)
                        }.disabled(item.url.isEmpty)
                        Button(action: {
                            // What to perform
                            self.order.add(item: self.item)
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: labelz.order.rawValue, someTextBottom: labelz.ingredients.rawValue, someImage: imagez.order.rawValue, reversed: false)
                        }
                        Button(action: {
                            self.addingImage.toggle()
                        }) {
                            RoundButton3View(someTextTop: labelz.add.rawValue, someTextBottom: labelz.images.rawValue, someImage: imagez.save.rawValue, reversed: false)
                        }
                        Button(action: {
                            self.addingNote.toggle()
                        }) {
                            RoundButton3View(someTextTop: labelz.add.rawValue, someTextBottom: labelz.notes.rawValue, someImage: imagez.save.rawValue, reversed: false)
                        }
                    }
                }
                if showingNotes == true {
                    NotesView(recipeuuid: self.item.id)
                }
                
                if showingImages == true {
                    ImagesView(recipeuuid: self.item.id)
                }
            }
            
            .sheet(isPresented: $addingImage) {
                AddImageView(recipeid: self.item.id)
            }
            .sheet(isPresented: $addingNote) {
                AddNoteView()
            }
            .sheet(isPresented: $showingRecipe) {
                SafariView(url: URL(string: self.item.url)!)
            }
            .sheet(isPresented: $showingInstructions) {
                LoadableSRecipeFromUrl(urlstr: self.item.url)
            }
            .sheet(isPresented: $showingNotes) {
                NotesView(recipeuuid: self.item.id)
            }
            
            .alert(isPresented: $recipeSaved)   {
                return Alert(title: Text("Saving Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle(Text(labelz.nbartitle.rawValue), displayMode: .inline)
        }
        .environment(order)
        .environment(aur)
        .environment(aun)
        .environment(aui)
    }
}


struct RecipeDetailView_Previews: PreviewProvider {
    // MARK: - View Process
    static var previews: some View {
        NavigationView {
            RecipeDetailView(sectionItem: SectionItem3.example3)
                .environment(OrderingList())
                .environment(AllUserRecipes())
                .environment(AllUserNotes())
                .environment(AllUserImages())
        }
    }
}
