//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    init(analyzedInstructions: AnalyzedInstructions) {
        self.myAnalyzedInstructions = analyzedInstructions
    }
    
    fileprivate var myAnalyzedInstructions: AnalyzedInstructions
    
    var body: some View {
        Text("The number of instructions is: " + (myAnalyzedInstructions.steps.count.description))
        List {
            ForEach(myAnalyzedInstructions.steps, id: \.self) { aStep in
                Section {
                    Text(aStep.number.description)
                    Text(aStep.step.description)
                }
            }.disabled(myAnalyzedInstructions.steps.count == 0)
        }
    }
}

#Preview {
    AnalyzedInstructionsView(analyzedInstructions: Bundle.main.decode(AnalyzedInstructions.self, from: .init("AnalyzedInstructionsExample.json")))
}
