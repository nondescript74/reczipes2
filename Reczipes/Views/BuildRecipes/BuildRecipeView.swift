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
        self.id = UUID()
        self.recipeName = "Z's Famous Recipe"
    }
    
    // MARK: - Environment Variables
    @EnvironmentObject var ingredients: RecipeIngredients
    @EnvironmentObject var instructions: RecipeInstructions
    @EnvironmentObject var images: RecipeImages
    @EnvironmentObject var rbb: RecipeBeingBuilt
    
    // MARK: - State
//    @State fileprivate var showingInstructions = false
//    @State fileprivate var showingImages = false
//    @State fileprivate var showingIngredients = false
    @State fileprivate var recipeName = ""
    // MARK: - Properties
    fileprivate var id: UUID
    
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
    
    fileprivate let decoder = JSONDecoder()
    
    // MARK:- Methods
    
    fileprivate func addIngredients() -> [ExtendedIngredient] {
        var myReturn = [ExtendedIngredient]()
        for anIngred in ingredients.ingredients {
            let anExtIng = ExtendedIngredient(name: anIngred.name)
            myReturn.append(anExtIng)
        }
        return myReturn
    }
    
    fileprivate func addInstructions() -> [Instruction] {
        var myReturn = [Instruction]()
        for anIns in instructions.instructions {
            let anInstr = Instruction(id: Int64.random(in: 0..<myMaxInt64), text: anIns.text)
            myReturn.append(anInstr)
        }
        return myReturn
    }
    
    fileprivate func saveIt() {
        let instructions = addInstructions()
        let ingredients = addIngredients()

    }
    
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    Text(msgs.br.rawValue).font(.largeTitle).bold()
                        .padding(.bottom)
                    VStack {
                        TextField("Enter a recipe name", text: $recipeName)
                    }.padding()
                    
                    HStack {
                        NavigationLink(destination: CreateSRecipeFieldsView()) {
                            Text("Create Recipe")
                        }
//                        NavigationLink(destination: AddInstructionsView()) {
//                            Text("Add Instructions")
//                        }
//
//                        NavigationLink(destination: AddIngredientView()) {
//                            Text("Add Ingredients")
//                        }
//
//                        NavigationLink(destination: AddImagesView(id: self.id)) {
//                            Text("Add Images")
//                        }
                    }

                    List {
                        Text("Recipe Instructions")
                        ForEach(instructions.instructions, id: \.self) { ins in
                            Text(ins.text)
                        }
                        Divider()
                    
                        Text("Recipe Ingredients")
                        ForEach(ingredients.ingredients, id: \.self) {ing in
                            Text(ing.name)
                        }
                        Divider()
                        
                        Text("Recipe Images")
                        ForEach(images.images, id: \.self) { imgSvd in
                            Image(uiImage: UIImage(data: imgSvd.imageSaved)!).disabled(images.total == 0)
                        }
                    }
                    HStack {
                        Button(action: {self.saveIt()}) {
                            RoundButton3View(someTextTop: msgs.savez.rawValue, someTextBottom: msgs.rec.rawValue, someImage: msgs.tor.rawValue)
                        }
                    }
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
