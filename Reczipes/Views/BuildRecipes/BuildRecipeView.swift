//
//  BuildRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct BuildRecipeView: View {
    // MARK: Initializer
    
    // MARK: - Environment Variables
    @EnvironmentObject var ingredients: RecipeIngredients
    @EnvironmentObject var instructions: RecipeInstructions
    @EnvironmentObject var images: RecipeImages
    
    // MARK: - State
    @State fileprivate var showingInstructions = false
    @State fileprivate var showingImages = false
    @State fileprivate var showingIngredients = false
    // MARK: - Properties
    //    enum Selectors {
    //        case notyet
    //        case ingred
    //        case instr
    //        case imgs
    //    }
    
    fileprivate enum msgs: String {
        case br = "Build A Recipe"
        case rec = "Recipe"
        case makeSelection = "Click One of the selections"
        case noTitle = "No Recipe Title"
        case noIngr = "No Ingredients Found?"
        case ingred = "Add Ingredients"
        case top = "Add"
        case ainsbottom = "Instructions"
        case ainsimg = "doc.on.doc"
        case aingbottom = "Ingredients"
        case aingimg = "questionmark.circle"
        case aimgsbottom = "Images"
        case aimgsimg = "lasso.sparkles"
        case savez = "Save"
        case tor = "tortoise"
    }
    
    // MARK:- Methods
    
    fileprivate func addIngredients() {
        var extIng = ExtendedIngredient.extendedIngredientExample
        
        
    }
    fileprivate func addInstructions() {
    }
    
    fileprivate func addImages() {
    }
    
    fileprivate func saveIt() {
        
        showingIngredients = false
        showingInstructions = false
        showingImages = false
        
        let mySRecipe = SRecipe(aggregateLikes: 0,
                                analyzedInstructions: [],
                                cheap: false,
                                cookingMinutes: 0,
                                creditsText: "Z. Premji",
                                cuisines: ["No cuisine"],
                                dairyFree: false,
                                diets: [],
                                dishTypes: [],
                                extendedIngredients: [],
                                gaps: "",
                                glutenFree: false,
                                healthScore: 0.0,
                                id: 99999999999,
                                image: "",
                                imageType: "",
                                instructions: "First",
                                license: "Z",
                                lowFodmap: false,
                                occasions: [],
                                originalId: "999999999",
                                preparationMinutes: 0,
                                pricePerServing: 0.0,
                                readyInMinutes: 0,
                                servings: 0,
                                sourceName: "Z",
                                spoonacularScore: 0.0,
                                spoonacularSourceUrl: "",
                                summary: "This is a good recipe",
                                sustainable: false,
                                title: "",
                                vegan: false,
                                vegetarian: false,
                                veryHealthy: false,
                                veryPopular: false,
                                weightWatcherSmartPoints: 0,
                                winePairing: WinePairing()
        )
        
    }
    
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    Text(msgs.br.rawValue).font(.largeTitle).bold()
                        .padding(.bottom)
                    Text(msgs.makeSelection.rawValue)
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        Button(action: {showingInstructions.toggle()}) {
                            RoundButton3View(someTextTop: msgs.top.rawValue, someTextBottom: msgs.ainsbottom.rawValue, someImage: msgs.ainsimg.rawValue)
                        }.padding()
                        Button(action: {showingIngredients.toggle()}) {
                            RoundButton3View(someTextTop: msgs.top.rawValue, someTextBottom: msgs.aingbottom.rawValue, someImage: msgs.aingimg.rawValue)
                        }.padding()
                        Button(action: {showingImages.toggle()}) {
                            RoundButton3View(someTextTop: msgs.top.rawValue, someTextBottom: msgs.aimgsbottom.rawValue, someImage: msgs.aingimg.rawValue)
                        }.padding()
                        Button(action: {self.saveIt()}) {
                            RoundButton3View(someTextTop: msgs.savez.rawValue, someTextBottom: msgs.rec.rawValue, someImage: msgs.tor.rawValue)
                        }.padding()
                    }
                    
                    NavigationLink(destination: AddInstructionsView()) {
                        Text("Add Instructions").disabled(!showingInstructions)
                    }.disabled(!showingInstructions)
                    
                    NavigationLink(destination: AddIngredientView()) {
                        Text("Add Ingredients").disabled(!showingIngredients)
                    }.disabled(!showingIngredients)
                    
                    NavigationLink(destination: AddImagesView()) {
                        Text("Add Images").disabled(!showingImages)
                    }.disabled(!showingImages)
                    
                }.padding(.bottom)
                    
            }
        }
    }
}

struct BuildRecipeView_Previews: PreviewProvider {
    static let recipIngreds = RecipeIngredients()
    static let recipInstrs = RecipeInstructions()
    static let recipImgs = RecipeImages()
    static var previews: some View {
        BuildRecipeView()
            .environmentObject(recipIngreds)
            .environmentObject(recipInstrs)
            .environmentObject(recipImgs)
    }
}
