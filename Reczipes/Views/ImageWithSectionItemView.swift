//
//  ImageWithSectionItemView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/5/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct ImageWithSectionItemView: View {
    // used in ExtendedIngredientsView
    // https://spoonacular.com/food-api/docs#Show-Images
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.item = extendedIngredient
#if DEBUG
        print("ImageWSecItemview: ", extendedIngredient.name ?? "No Name??")
#endif
    }
    // MARK: - Properties
    var item: ExtendedIngredient
    
    // MARK: - Methods
    fileprivate func createUrlString() -> String {
        var urlString = "https://img.spoonacular.com/ingredients_250x250/"
        urlString = urlString + item.image!
#if DEBUG
        print("ImageWSecItemview: ", urlString)
#endif
        return urlString
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: createUrlString())) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .accessibility(hidden: false)
                        .accessibilityLabel(Text(item.name ?? "No name"))
                } else {
                    ProgressView()
                }
            }
        }
    }
}


struct ImageWithSectionItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageWithSectionItemView(extendedIngredient:  ExtendedIngredient.extendedIngredientExample)
        }
    }
}

