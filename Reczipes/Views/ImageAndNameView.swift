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
    // MARK: Methods
    // MARK: - View Process
    var body: some View {
        HStack(alignment: .center) {
            ImageWithSectionItemView(extendedIngredient: myExtIngredient)
            Text(myExtIngredient.name ?? msgs.noIngredName.rawValue)
                .font(.headline)
                .padding(.leading)
        }
    }
}

#Preview {
    ImageAndNameView(extendedIngredient: ExtendedIngredient.extendedIngredientExample)
}
