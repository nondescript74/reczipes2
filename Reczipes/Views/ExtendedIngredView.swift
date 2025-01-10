//
//  ExtendedIngredView.swift
//  ZTester4
//
//  Created by Zahirudeen Premji on 11/22/20.
//

import SwiftUI

struct ExtendedIngredView: View {
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.myExtIngredient = extendedIngredient
    }
    // MARK: - EnvironmentObjects
    @EnvironmentObject var ratio: RecipeRatio
    // MARK: - Properties
    fileprivate var myExtIngredient: ExtendedIngredient
    // MARK: - Methods
    fileprivate func getMetaInfo(meta: [String?]?) -> String {
        var myReturnMetaInfo: String = ""
        if meta != nil {
            if !meta!.isEmpty {
                for item in meta! {
                    myReturnMetaInfo += item!
                    myReturnMetaInfo += ", "
                }
            } else {
                myReturnMetaInfo = "meta: empty"
            }
        } else {
            
        }
        return myReturnMetaInfo
    }
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            ImageAndNameView(extendedIngredient: myExtIngredient)
            MeasuresView(measures: myExtIngredient.measures ?? Measures.measuresExample)
            Text(getMetaInfo(meta: myExtIngredient.metaInformation))
        }
        .padding()
        .environmentObject(ratio)
    }
}

struct ExtendedIngredView_Previews: PreviewProvider {
    static var previews: some View {
        ExtendedIngredView(extendedIngredient: ExtendedIngredient.extendedIngredientExample)
            .environmentObject(RecipeRatio())
    }
}
