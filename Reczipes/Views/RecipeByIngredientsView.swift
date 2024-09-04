//
//  RecipeByIngredientsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 8/30/24.
//

import SwiftUI

struct RecipeByIngredientsView: View {
    
    // MARK: - ObservedObject
    //MARK: - Environment
    @EnvironmentObject var swri: SRecipeWithInfo
    
    init(cRecipe: CRecipe) {
        self.cRecipe = cRecipe
    }
    
    fileprivate var cRecipe: CRecipe
    
    fileprivate func executeTheQuery() async {
        await swri.executeQuery(recipeId: cRecipe.id)
    }
    
    fileprivate enum imagez: String {
        case kv = "key"
    }
    
    
    var body: some View {
        NavigationLink(destination:
                        RecipeDetailView(imageString: cRecipe.image,
                                         sectionItem: convertSRecipeToSectionItem3(srecipe: swri.result),
                                         cuisine: (swri.result.cuisines?.first)!!))
        {
            VStack(alignment: .center) {
                Text(self.cRecipe.title)
                Text(self.cRecipe.id.description)
                
                
                Button(action: {
                    // What to perform
                    Task {
                        await executeTheQuery()
                    }
                }) {
                    // How the button looks like
                    RoundButton3View(someTextTop: "Get", someTextBottom: "SRecipe", someImage: imagez.kv.rawValue, reversed: true)
                }
                
                Text(swri.result.title ?? "No title")
            }.padding()
            
        }
    }
}

#Preview {
    RecipeByIngredientsView(cRecipe: CRecipe.cRecipeExample)
        .environmentObject(SRecipeWithInfo())
}
