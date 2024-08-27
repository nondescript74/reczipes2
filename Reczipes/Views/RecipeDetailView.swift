//
//  RecipeDetailView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI
import MessageUI

struct RecipeDetailView: View {
    // MARK: - Local debug flag
    fileprivate var zBug: Bool = false
    //MARK: - Environment
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var myAI: AnalyzedInstructionsModel
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Initializer
    init(imageString: String, sectionItem: SectionItem3, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
        anImage.getImageFromUrl(urlString: imageString, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
    }
    // MARK: - Properties
    var item: SectionItem3
    var cuisine: String = ""
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
        case noai = "Number of Analyzed Instructions is greater than 1? "
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
    @State fileprivate var showingInstructions = false
    @State fileprivate var showShareSheet = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State fileprivate var recipeSaved = false
    @State fileprivate var showingMoveView = false
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    
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
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    if UIImage(named: item.mainImage) == nil {
                        anImage.anImage?
                            .resizable()
                            .padding(.all, 5)
                            .frame(width: proxy.size.width / 2, height: proxy.size.height / 4)
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
                        Task {
                            await myAI.executeQuery(recipeId: self.item.recipeId!)
                            self.showingInstructions = true
                        }
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.instr.rawValue, someImage: imagez.instr.rawValue, reversed: true)
                    }.disabled(item.recipeId == nil)
                }
                Divider()
                if showingNotes == true && hasNotes() {
                    NotesView(recipeuuid: self.item.id)
                }
                Divider()
                if showingImages == true && hasImages() {
                    ImagesView(recipeuuid: self.item.id)
                }
                Divider()
                if showingInstructions == true  {
                    AnalyzedInstructionsView(analyzedInstructions: myAI.result)
                }
            }
            .sheet(isPresented: $addingImage) {
                AddImageView()
            }
            .sheet(isPresented: $addingNote) {
                AddNoteView()
            }
//            .sheet(isPresented: $showingInstructions) {
//                AnalyzedInstructionsView(analyzedInstructions: myAI.result)
//            }
            
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
    static let aur = AllUserRecipes()
    static let aun = AllUserNotes()
    static let aui = AllUserImages()
    static let myAi = AnalyzedInstructionsModel()
    // MARK: - View Process
    static var previews: some View {
        NavigationView {
            RecipeDetailView(imageString: defaultImageUrl, sectionItem: SectionItem3.example3, cuisine: aur.getBookSectionNames().last!)
                .environmentObject(order)
                .environmentObject(aur)
                .environmentObject(aun)
                .environmentObject(aui)
                .environmentObject(myAi)
        }
    }
}
