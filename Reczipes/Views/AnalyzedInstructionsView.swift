//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    @EnvironmentObject var instructions: AnalyzedInstructionsModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("The number of instructions is: " + instructions.result.count.description)
                    .font(.title)
                
                ForEach(instructions.result, id: \.self) { anInstruction in
                    Text(anInstruction.name)
                        .font(.headline)
                    List {
                        ForEach(anInstruction.steps, id: \.self) { aStep in
                            HStack {
                                Text(aStep.number.description)
                                Text(aStep.step.description)
                            }
                        }
                    }
                }
                .navigationBarTitle("Analyzed Instructions")
            }
        }
    }
}

#Preview {
    AnalyzedInstructionsView()
        .environmentObject(AnalyzedInstructionsModel())
}
