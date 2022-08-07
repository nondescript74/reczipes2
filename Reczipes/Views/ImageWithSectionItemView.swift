//
//  ImageWithSectionItemView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/5/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct ImageWithSectionItemView: View {  // used in ExtendedIngredientsView
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.item = extendedIngredient
        
        #if DEBUG
        print(extendedIngredient.name ?? "No Name??")
        #endif
        
        anImage.getImageFromUrl(urlString: extendedIngredient.image ?? "Default Image", type: WebQueryRecipes.callerId.webimage)
    }
    // MARK: - Properties
    var item: ExtendedIngredient
    var body: some View {
        VStack(alignment: .leading) {
            anImage.anImage.scaleEffect(CGSize(width: 1.2, height: 1.2))
                .disabled(anImage.anImage == nil)
        }
    }
}

#if DEBUG
struct ImageWithSectionItemView_Previews: PreviewProvider {
    static let order = OrderingList()
    static var previews: some View {
        Group {
            ImageWithSectionItemView(extendedIngredient:  ExtendedIngredient.extendedIngredientExample)
                .environmentObject(order)
                .previewDevice("iPhone Xr")
        }
    }
}
#endif
