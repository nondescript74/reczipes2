//
//  ImageAndNameView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/25/24.
//

import SwiftUI
import os

struct ImageAndNameView: View {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "ImageAndNameView")
    
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.myExtIngredient = extendedIngredient
        logger.info("ImageAndNameView: initialized")
    }
    
    // MARK: - Properties
    fileprivate var myExtIngredient: ExtendedIngredient!
    
    // MARK: - Methods
    fileprivate func createUrlString() -> String {
        var urlString = "https://img.spoonacular.com/ingredients_250x250/"
        if myExtIngredient.image == nil {
            urlString = "https://img.spoonacular.com/recipes/929118-312x231.jpg"
            logger.error( "ImageAndNameView: No image found for myExtIngredient")
        } else {
            urlString = urlString + myExtIngredient.image!
            logger.info("ImageAndNameView: Image found for myExtIngredient, created urlString: \(urlString)")
        }
        
        return urlString
    }

    // MARK: - View Process
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: createUrlString())) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    } else {
                        ProgressView()
                    }
                }
            }

            Text(myExtIngredient.name ?? "ImageAndNameView: No name")
                .font(.headline)
                .padding(.leading)
        }
    }
}

#Preview {
    ImageAndNameView(extendedIngredient: ExtendedIngredient.extendedIngredientExample)
}
