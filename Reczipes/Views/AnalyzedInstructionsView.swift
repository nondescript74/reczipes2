//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    init(srecipe: SRecipe) {
        self.recipe = srecipe
    }
    
    fileprivate var recipe: SRecipe
    
    var body: some View {
        Text("The number of instructions is: " )
            .font(.title)
        
        ForEach(myAnalyzedInstructions, id: \.self) { anInstruction in
            Text(anInstruction.name)
                .font(.headline)
            List {
                ForEach(anInstruction.steps, id: \.self) { aStep in
                    HStack {
                        Text(aStep.number.description)
                        Text(aStep.step.description)
                    }
                }.disabled(myAnalyzedInstructions.first!.steps.count == 0)
            }
        }
    }
}

#Preview {
    AnalyzedInstructionsView(sectionItem: Bundle.main.decode(SectionItem3.self, from: "AnalyzedInstructionsExample2.json"))
}
