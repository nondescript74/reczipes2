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
        Text("The number of instructions is: " + (myAnalyzedInstructions.analyzedInstructions.count.description))
        List {
            ForEach(myAnalyzedInstructions.analyzedInstructions, id: \.self) { aInst in
                Text(aInst.name)
                ForEach(aInst.steps, id: \.self) { aStep in
                    Text(aStep.number.description)
                }
            }.disabled(myAnalyzedInstructions.analyzedInstructions.count == 0)
        }
    }
}

#Preview {
    AnalyzedInstructionsView(analyzedInstructions: Bundle.main.decode(AnalyzedInstructions.self, from: .init("AnalyzedInstructionsExample.json")))
}
