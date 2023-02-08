//
//  RecipeRowNNLView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/7/23.
//

import SwiftUI

struct RecipeRowNNLView: View {
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
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
            print("No imageUrl")
#endif
        } else {
#if DEBUG
            print("imageUrl exists, going to get")
#endif
            anImage.getImageFromUrl(urlString: sRecipe.image!, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        }
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

    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                anImage.anImage?
                    .resizable()
                    .scaledToFill()
                    .frame(width: widthImage, height: heightImage, alignment: .leading)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.gray, lineWidth: overlayLWidth))
                
                Text(sRecipe.title ?? "No Title")
                
                Button(action: {
                    // What to perform
                    let result = aur.addRecipe(bsectionid: aur.getBookSectionIDForName(name: cuisine), recipe: convertSRecipeToSectionItem(srecipe: sRecipe))
                    if result { recipeSaved = true } else { recipeSaved = false }
                }) {
                    // How the button looks like
                    RoundButton3View(someTextTop: labelz.save.rawValue, someTextBottom: labelz.recipe.rawValue, someImage: imagez.add.rawValue, reversed: false)
                }.disabled(cuisine.isEmpty )

            }
            Spacer()
            HStack {
                ForEach(constructRestrictionsWithSRecipe(srecipe: sRecipe), id: \.self) { restriction in
                    Text(restriction)
                        .font(.caption)
                        .padding(paddingSize)
                        .clipShape(Rectangle())
                }
            }
        }
        .alert(isPresented: $recipeSaved)   {
            return Alert(title: Text("Saving Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
        }
    }
}

struct RecipeRowNNLView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRowView(sectionItem: SectionItem.example, cuisine: "Indian")
    }
}
