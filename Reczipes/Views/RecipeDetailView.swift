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
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    @EnvironmentObject var aun: AllUserNotes
    // MARK: - Initializer
    init(imageString: String, sectionItem: SectionItem3, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
    }
    // MARK: - Properties
    fileprivate var item: SectionItem3
    fileprivate var cuisine: String
    
    fileprivate enum msgs: String {
        case recipeDetailView, RDV = "RecipeDetailView: "
        case norid = "No RecipeId"
        case ridltz = "RecipeId is negative"
        case ridgnnn = "RecipeId is greater or equal to 9999999"
        case riiv = "RecipeId is valid"
        case ro = "result number of steps obtained is "
        case irid = "invalid recipeid sent in"
        case cnd = "could not decode AnalyzedInstructions from data"
        case nk = "No Api Key"
    }
    
    fileprivate enum labelz: String {
        case order = "Order"
        case save = "Save"
        case share = "Share"
        case recipe = "This"
        case ingredients = "Ingred"
        case show = "Show"
        case notes = "Notes"
        case images = "Images"
        case instr = "Instr"
        case nbartitle = "Recipe Details"
        
    }
    
    fileprivate enum imagez: String {
        case order = "list.clipboard"
        case book = "book"
        case images = "photo.stack"
        case save = "externaldrive.badge.plus"
        case share = "square.and.arrow.up"
        case instr = "list.bullet.clipboard.fill"
    }
    
    // MARK: - State
    @State fileprivate var showingNotes = false
    @State fileprivate var showingImages = false
    @State fileprivate var addingImage = false
    @State fileprivate var addingNote = false
    @State fileprivate var showShareSheet = false
    @State fileprivate var recipeSaved = false
    @State fileprivate var showingInstructions = false
    @State fileprivate var instructions: [AnalyzedInstructions] = []
    
    // MARK: - Methods
    fileprivate func hasNotes() -> Bool {
        var userNotes = aun.notes
        userNotes = userNotes.filter({$0.recipeuuid == item.id})
        if userNotes.isEmpty {
            return false
        }
        return true
    }
    
    fileprivate func hasImages() -> Bool {
        var imageSaveds = aui.images
        imageSaveds = imageSaveds.filter({$0.recipeuuid == item.id})
        if imageSaveds.isEmpty {
            return false
        }
        return true
    }
    
    fileprivate func searchAnalyzedInstructions(matching id: Int) async -> Bool {
        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
        
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?" + key)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            // check for empty array
            if data.isEmpty {
#if DEBUG
                print("\(msgs.RDV.rawValue) \(id) data is empty")
#endif
                instructions = []
                return false
            }
            instructions = try JSONDecoder().decode([AnalyzedInstructions].self, from: data)
#if DEBUG
            print("\(msgs.RDV.rawValue) \(id) decoded")
#endif
            return true
        } catch  {
#if DEBUG
            print("\(msgs.cnd.rawValue) \(id)")
            instructions = []
#endif
            return false
        }
    }
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    AsyncImage(url: URL(string: (item.imageUrl ?? SectionItem3.example.imageUrl)!)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .accessibility(hidden: false)
                                .accessibilityLabel(Text(item.name))
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
                        let result = aur.addRecipe(bsectionid: aur.getBookSectionIDForName(name: cuisine), recipe: self.item)
                        if result { recipeSaved = true } else { recipeSaved = false }
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.save.rawValue, someTextBottom: labelz.recipe.rawValue, someImage: imagez.save.rawValue, reversed: false)
                    }.disabled(cuisine.isEmpty )
                    Button(action: {
                        // What to perform
                        self.order.add(item: self.item)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.order.rawValue, someTextBottom: labelz.ingredients.rawValue, someImage: imagez.order.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        self.showingNotes.toggle()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.notes.rawValue, someImage: imagez.book.rawValue, reversed: true)
                    }.disabled(!self.hasNotes())
                    Button(action: {
                        // What to perform
                        self.showingImages.toggle()
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.images.rawValue, someImage: imagez.images.rawValue, reversed: true)
                    }.disabled(!self.hasImages())
                    Button(action: {
                        // What to perform
                        self.showingInstructions.toggle()
//                        Task {
//                            let result = await searchAnalyzedInstructions(matching: self.item.recipeId!)
//                            if result {
//                                self.showingInstructions = true
//                            } else {
//                                print("RDV : No instructions found")
//                            }
//                        }
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.instr.rawValue, someImage: imagez.instr.rawValue, reversed: true)
                    }.disabled(item.recipeId == nil || item.recipeId == -1 || item.recipeId! >= 9999999)
                }

                if showingNotes == true && hasNotes() {
                    NotesView(recipeuuid: self.item.id)
                }

                if showingImages == true && hasImages() {
                    ImagesView(recipeuuid: self.item.id)
                }

                if showingInstructions == true  {
//                    let result = await searchAnalyzedInstructions(matching: self.item.recipeId!)
                }
            }
            .sheet(isPresented: $addingImage) {
                AddImageView()
            }
            .sheet(isPresented: $addingNote) {
                AddNoteView()
            }
            
            .alert(isPresented: $recipeSaved)   {
                return Alert(title: Text("Saving Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle(Text(labelz.nbartitle.rawValue), displayMode: .inline)
        }
        .environmentObject(order)
        .environmentObject(aur)
        .environmentObject(aun)
        .environmentObject(aui)
    }
}


struct RecipeDetailView_Previews: PreviewProvider {
    // MARK: - Environment
    static let order = OrderingList()
    static let aur = AllUserRecipes()
    static let aun = AllUserNotes()
    static let aui = AllUserImages()
    // MARK: - View Process
    static var previews: some View {
        NavigationView {
            RecipeDetailView(imageString: defaultImageUrl, sectionItem: SectionItem3.example3, cuisine: aur.getBookSectionNames().last!)
                .environmentObject(order)
                .environmentObject(aur)
                .environmentObject(aun)
                .environmentObject(aui)
        }
    }
}
