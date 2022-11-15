//
//  CRecipeRowView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/14/22.
//

import SwiftUI

struct CRecipeRowView: View {
    // MARK: - Debug
    private var zBug: Bool = false
    // MARK: - Environment
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    @ObservedObject var theSRecipeInfo = WebQueryRecipes()  // need to get this asynch just like the image
    // MARK: - Initializer
    init(crecipe: CRecipe, cuisine: String) {
        self.item = crecipe
        self.cuisine = cuisine
        // check for empty
        if item.image == "" {
            // no image
        } else {
            anImage.getImageFromUrl(urlString: item.image, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        }
        theSRecipeInfo.getMySRecipeInfo(id: crecipe.id)
    }
    
    // MARK: - Properties
    fileprivate var item: CRecipe
    fileprivate var cuisine: String = ""
    private let widthImage: CGFloat = 100
    private let heightImage: CGFloat = 70
    private let overlayLWidth: CGFloat = 2
    private let paddingSize: CGFloat = 2
    private let lineLimit: Int = 3
    
    // MARK: - Methods
    
    // MARK: - View Process
    var body: some View {
        NavigationLink(destination: RecipeDetailView(imageString: item.image, crecipe: item, cuisine: cuisine)) {
            
            VStack(alignment: .leading) {
                
                anImage.anImage?
                    .resizable()
                    .scaledToFill()
                    .frame(width: widthImage, height: heightImage, alignment: .leading)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.gray, lineWidth: overlayLWidth))
                
                Text(item.title)
                
            }
        }
    }
}


struct CRecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CRecipeRowView(crecipe: CRecipe.cRecipeExample, cuisine: "Indian")
        }.previewDevice("iPhone Xr")
    }
}
