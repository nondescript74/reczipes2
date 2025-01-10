//
//  ImageWithSectionItemView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/5/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct ImageWithSectionItemView: View {  // used in ExtendedIngredientsView
//    // MARK: - ObservedObject
//    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.item = extendedIngredient
//#if DEBUG
//        print(extendedIngredient.name ?? "No Name??")
//#endif
//        anImage.getImageFromUrl(urlString: extendedIngredient.image ?? "Default Image", type: callerId.webimage)
    }
    // MARK: - Properties
    var item: ExtendedIngredient
    
    // MARK: - Methods
    fileprivate func createUrlString() -> String {
        var urlString = "https://img.spoonacular.com/recipes/"
        urlString = urlString + item.id!.description + "-556x370.jpg"
#if DEBUG
        print(urlString)
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
                }  else if phase.error != nil  {
                    VStack {
                        Image("IMG_Rae_312x312")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                        Text("The recipes were all busy.")
                            .font(.title2)
                        Text("Please try again.")
                            .font(.title3)
                    }
                    
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

