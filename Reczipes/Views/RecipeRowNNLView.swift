//
//  RecipeRowNNLView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/7/23.
//

import SwiftUI

struct RecipeRowNNLView: View {
    //MARK: - Environment
    @EnvironmentObject var aur: AllUserRecipes
    // MARK: - Initializer
    init(srecipe: SRecipe, cuisine: String) {
        self.sRecipe = srecipe
        self.cuisine = cuisine
        // check for empty
        if sRecipe.image == nil {
            // can't call to get image without url
#if DEBUG
            print("RRNNLV: No imageUrl")
#endif
        }
#if DEBUG
        print("RRNNLV: The recipeId is :", srecipe.id, "The cuisine is :", cuisine, "\n")
        print("RRNNLV: The recipe title is :", sRecipe.title ?? "No Title")
#endif
    }
    // MARK: - State
    @State fileprivate var recipeSaved = false
    // MARK: - Properties
    fileprivate var sRecipe: SRecipe
    fileprivate var cuisine: String = ""
    fileprivate enum labelz: String {
        case save = "Save"
        case recipe = "This"
    }
    
    fileprivate enum imagez: String {
        case add = "plus"
    }
    // MARK: Methods
    fileprivate var renderingText: String {
        return ""
    }
    
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(sRecipe.title ?? "No Title")
                    .font(.headline)
                    .padding()
                Spacer()
            }
            
            AsyncImage(url: URL(string: (sRecipe.image ?? SRecipe.example2.image)!)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .frame(alignment: .center)
                        .padding()
                    
                } else {
                    ProgressView()
                }
            }
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    ForEach(constructRestrictionsWithSRecipe(srecipe: sRecipe), id: \.self) { restriction in
                        Text(restriction)
                    }
                    .padding(.horizontal)
                    
                }
                Spacer()
                Button(action: {
                    // What to perform
                    let result = aur.addRecipe(bsectionid: aur.getBookSectionIDForName(name: cuisine), recipe: convertSRecipeToSectionItem3(srecipe: sRecipe))
                    recipeSaved = result
                }) {
                    // How the button looks like
                    RoundButton3View(someTextTop: labelz.save.rawValue, someTextBottom: labelz.recipe.rawValue, someImage: imagez.add.rawValue, reversed: cuisine.isEmpty)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text(sRecipe.summary ?? "No summary")
    
            }
        }
        .environmentObject(aur)
        .alert(isPresented: $recipeSaved)   {
            return Alert(title: Text("Saving Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
        }
    }
}

struct RecipeRowNNLView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRowNNLView(srecipe: SRecipe.example2, cuisine: "Asian")
            .environmentObject(AllUserRecipes())
    }
}
