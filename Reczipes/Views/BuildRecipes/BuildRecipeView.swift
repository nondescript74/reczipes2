//
//  BuildRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct BuildRecipeView: View {
    // MARK: Initializer
    init() {
        show = .notyet
    }
    // MARK: - Environment Variables
    @EnvironmentObject var ingredients: RecipeIngredients
    @EnvironmentObject var instructions: RecipeInstructions
    @EnvironmentObject var images: RecipeImages

    // MARK: - State
    @State var show: Selectors
    // MARK: - Properties
    enum Selectors {
        case notyet
        case ingred
        case instr
        case imgs
    }
    
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
        show = Selectors.ingred
    }
    fileprivate func addInstructions() {
        show = Selectors.instr
    }
    
    fileprivate func addImages() {
        show = Selectors.imgs
    }
    
    fileprivate func saveIt() {
        show = Selectors.notyet
        let extIng = ExtendedIngredient()
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
                        Button(action: {self.addInstructions()}) {
                            RoundButton3View(someTextTop: msgs.top.rawValue, someTextBottom: msgs.ainsbottom.rawValue, someImage: msgs.ainsimg.rawValue)
                        }.padding()
                        Button(action: {self.addIngredients()}) {
                            RoundButton3View(someTextTop: msgs.top.rawValue, someTextBottom: msgs.aingbottom.rawValue, someImage: msgs.aingimg.rawValue)
                        }.padding()
                        Button(action: {self.addImages()}) {
                            RoundButton3View(someTextTop: msgs.top.rawValue, someTextBottom: msgs.aimgsbottom.rawValue, someImage: msgs.aingimg.rawValue)
                        }.padding()
                        Button(action: {self.saveIt()}) {
                            RoundButton3View(someTextTop: msgs.savez.rawValue, someTextBottom: msgs.rec.rawValue, someImage: msgs.tor.rawValue)
                        }.padding()
                    }
                    
                    VStack {
                        
                        NavigationLink(destination: AddInstructionsView()) {
                            Text("Adding Instructions ...")
                        }.padding(.bottom).disabled(show != .instr)
                        
                        NavigationLink(destination: AddIngredientView()) {
                            Text("Adding Ingredients ...")
                        }.padding(.bottom).disabled(show != .ingred)
                        
                        NavigationLink(destination: AddImagesView()) {
                            Text("Adding Pictures ...")
                        }.padding(.bottom).disabled(show != .imgs)
                    }
                    
                    VStack {
                        Text("Recipe Ingredients").foregroundColor(.gray)
                        ForEach(ingredients.ingredients, id: \.self) { ingred in
                            Text(ingred.name)
                        }
                    }.padding(.bottom)
                    
                    VStack {
                        Text("Recipe Instructions").foregroundColor(.gray)
                        ForEach(instructions.instructions, id:\.self) { instr in
                            Text(instr.text)
                        }
                    }.padding(.bottom)
                    
                    VStack {
                        Text("Recipe Images") 
                    }.padding(.bottom)
                    
                    
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
