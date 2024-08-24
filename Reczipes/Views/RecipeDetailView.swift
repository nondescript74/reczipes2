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
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
//    @ObservedObject var analyInstr = AnalyzedInstructionsModel()
    // MARK: - Initializer
    init(imageString: String, sectionItem: SectionItem3, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
        anImage.getImageFromUrl(urlString: imageString, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
//        analyInstr.executeQuery(recipeId: item.recipeId ?? 324624)
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
//    fileprivate var analyInstr: AnalyzedInstructions?
    
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
    
    fileprivate func hasAnalyzedInstructions() async -> Bool {
        if item.recipeId == nil {
#if DEBUG
            print(msgs.RDV.rawValue, msgs.norid.rawValue)
#endif
            return false
        }
        if item.recipeId! <= 0 {
#if DEBUG
            print(msgs.RDV.rawValue, msgs.ridltz.rawValue)
#endif
            return false
        }
        if item.recipeId! >= 9999999 {
#if DEBUG
            print(msgs.RDV.rawValue, msgs.ridgnnn.rawValue)
#endif
            return false
        }
//        await analyInstr.executeQuery(recipeId: item.recipeId ?? 324624)
        return false
    }
    
//    fileprivate func checkRecipeIdValid(recipeid: Int?) -> Bool {
//        if recipeid == nil {
//#if DEBUG
//            print(msgs.RDV.rawValue, "recipe id supplied is nil")
//#endif
//            return false
//        } else
//        if recipeid! <= 0 {
//#if DEBUG
//            print(msgs.RDV.rawValue, msgs.ridltz.rawValue)
//#endif
//            return false
//        } else
//        if recipeid! >= 9999999 {
//#if DEBUG
//            print(msgs.RDV.rawValue, msgs.ridgnnn.rawValue)
//#endif
//            return false
//        } else {
//#if DEBUG
//            print(msgs.RDV.rawValue, msgs.riiv.rawValue)
//#endif
//            return true
//        }
//    }
    
//    fileprivate func searchAnalyzedInstructions(matching id: Int) async -> AnalyzedInstructions {
//        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
//        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?" + key)
//#if DEBUG
//        if zBug {print(msgs.RDV.rawValue + url!.absoluteString)}
//#endif
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url!)
//            let ai = try JSONDecoder().decode(AnalyzedInstructions.self, from: data)
//#if DEBUG
//            if zBug {print(msgs.RDV.rawValue, ai)}
//            if zBug {print(msgs.noai.rawValue, ai.setOfAnalyzedInstruction.count.description)}
//#endif
//            return ai
//        } catch  {
//            fatalError(msgs.RDV.rawValue + msgs.cnd.rawValue)
//        }
//    }
    

    
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
                            if await hasAnalyzedInstructions() == true {
                                self.showingInstructions = true
                            }
                        }
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.show.rawValue, someTextBottom: labelz.instr.rawValue, someImage: imagez.instr.rawValue, reversed: false)
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
            }
            .sheet(isPresented: $addingImage) {
                AddImageView()
            }
            .sheet(isPresented: $addingNote) {
                AddNoteView()
            }
            .sheet(isPresented: $showingInstructions) {
//                InstructionsDisplayView(analyzedInstructions: analyInstr.result ?? AnalyzedInstructions.analyInstrExample)
//                AnalyzedInstructionsView (analyzedInstructions: <#AnalyzedInstructions#>)
            }
//            .sheet(isPresented: $showShareSheet) {
//                ShareRecipeView(sectionItem: item)
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
