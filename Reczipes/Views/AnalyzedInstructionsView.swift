//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    init(analyzedInstructions: [AnalyzedInstructions]) {
        self.myAnalyzedInstructions = analyzedInstructions
    }
    
    fileprivate var myAnalyzedInstructions: [AnalyzedInstructions]
    
    var body: some View {
        Text("The number of instructions is: " + (myAnalyzedInstructions.count.description))
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
    AnalyzedInstructionsView(analyzedInstructions: Bundle.main.decode([AnalyzedInstructions].self, from: "AnalyzedInstructionsExample3.json"))
}
