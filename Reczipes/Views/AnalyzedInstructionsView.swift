//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    var ainstructions: [AnalyzedInstructions]
    
    var body: some View {
//        NavigationView {
            VStack {
                Text("The number of instructions is: " + ainstructions.count.description)
                
                ForEach(ainstructions, id: \.self) { anInstruction in
                    Text("Instruction Name: " + anInstruction.name)
                        .font(.headline)
                    Text("Number of steps: " + anInstruction.steps.count.description + "")
                    List {
                        ForEach(anInstruction.steps, id: \.self) { aStep in
                            VStack(alignment: .leading) {
                                Text(aStep.number.description)
                                Text(aStep.step.description)
                            }
                        }
                    }
                }
//                .navigationBarTitle("Analyzed Instructions")
            }
//        }
    }
}

#Preview {
    AnalyzedInstructionsView(ainstructions: Bundle.main.decode([AnalyzedInstructions].self, from: "AnalyzedInstructionsExample.json"))
}
