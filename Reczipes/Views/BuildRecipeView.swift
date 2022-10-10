//
//  BuildRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct BuildRecipeView: View {
    // MARK: - ObservedObject
    @ObservedObject var ingredient = WebQueryRecipes()
    
    // MARK: - State
    @State var show: Selectors
    @State fileprivate var ingredients: [Ingredient] = []
    // MARK: - Properties
    enum Selectors {
        case notyet
        case ingred
        case instr
        case imgs
    }
    
    private enum msgs: String {
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
    
    func addIngredients() {
        show = Selectors.ingred
        ingredient.getJoke()
    }
    func addInstructions() {
        show = Selectors.instr
    }
    
    func addImages() {
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
                    
                    
                    List   {
//                        BuildRowView(mori: "metric")
                        if show == Selectors.notyet {
                            Text("No activity")
                        }
                        if show == Selectors.ingred {
//                            Text(ingredient.joke?.text ?? msgs.noIngr.rawValue)
//                                .lineLimit(20)
                        }
                        if show == Selectors.instr {
                            Text(ingredient.joke?.text ?? msgs.noIngr.rawValue)
                                .lineLimit(20)
                        }
                        if show == Selectors.imgs {
                            Text(ingredient.joke?.text ?? msgs.noIngr.rawValue)
                                .lineLimit(20)
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        
    }
}

struct BuildRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRecipeView(show: .notyet)
    }
}
