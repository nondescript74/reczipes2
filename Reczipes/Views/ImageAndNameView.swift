//
//  ImageAndNameView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/25/24.
//

import SwiftUI

struct ImageAndNameView: View {
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.myExtIngredient = extendedIngredient
    }
    
    // MARK: - Properties
    fileprivate var myExtIngredient: ExtendedIngredient!
    fileprivate enum msgs: String {
        case noIngredName = "No Ingredient Name??"
    }
    
    // https://spoonacular.com/food-api/docs#Show-Images
    
    // MARK: - Methods
    fileprivate func createUrlString() -> String {
        var urlString = "https://img.spoonacular.com/ingredients_250x250/"
        urlString = urlString + myExtIngredient.image!
#if DEBUG
        print("ImageWSecItemview: ", urlString)
#endif
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
                            .accessibility(hidden: false)
                            .accessibilityLabel(Text(myExtIngredient.name ?? "No name"))
                    } else {
                        ProgressView()
                    }
                }
            }

            Text(myExtIngredient.name ?? msgs.noIngredName.rawValue)
                .font(.headline)
                .padding(.leading)
        }
    }
}

#Preview {
    ImageAndNameView(extendedIngredient: ExtendedIngredient.extendedIngredientExample)
}
