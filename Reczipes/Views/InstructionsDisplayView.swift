//
//  InstructionsDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import SwiftUI

struct InstructionsDisplayView: View {
    @ObservedObject var analyInstr = WebQueryRecipes()
    // MARK: - Initializer
    init(sectionItem: SectionItem) {
        self.myItem = sectionItem
        analyInstr.getAnalyzedInstructions(recipeID: 488733)
    }
    // MARK: - Properties
    private var myItem: SectionItem?
    private var analyInstrSet: AnalyzedInstructions?

    var body: some View {
        List {
            if analyInstr.analyzedInstructions == nil {
                 
            } else {
                ForEach(analyInstrSet?.steps! ?? [Step.stepExample], id: \.self) { aStep in
                    Text(aStep?.number?.description ?? "0" + (aStep?.step ?? "no step"))
                }
            }
        }
    }
}

struct InstructionsDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsDisplayView(sectionItem: SectionItem.example)}
}
