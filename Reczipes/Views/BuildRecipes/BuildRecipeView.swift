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
                    }
                    
                    VStack {
                        NavigationLink(destination: AddIngredientView()) {
                            Text("Adding Ingredients ...")
                        }.padding(.bottom).disabled(show != .ingred)
                        
                        NavigationLink(destination: AddInstructionsView()) {
                            Text("Adding Instructions ...")
                        }.padding(.bottom).disabled(show != .instr)
                        
                        NavigationLink(destination: AddImagesView()) {
                            Text("Adding Pictures ...")
                        }.padding(.bottom).disabled(show != .imgs)
                    }
                    
                    VStack {
                        Text("Recipe Ingredients").foregroundColor(.gray)
                        ForEach(ingredients.ingredients, id: \.self) { ingred in
                            Text(ingred.name)
                        }
                        Text("Recipe Instructions").foregroundColor(.gray)
                        ForEach(instructions.instructions, id:\.self) { instr in
                            Text(instr.text)
                        }
                        Text("Recipe Images") 
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
