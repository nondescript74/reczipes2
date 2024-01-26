//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    init(analyzedInstructions: AnalyzedInstructions) {
        self.myAnalyInstr = analyzedInstructions
    }
    
    fileprivate var myAnalyInstr: AnalyzedInstructions?
    
    var body: some View {
        Text("The number of steps is: " + (myAnalyInstr?.steps?.count.description ?? "No Steps"))
        List {
            ForEach((myAnalyInstr?.steps)!, id: \.self) { aStep in
                Text(aStep!.step ?? "Step has no description")
            }.disabled(myAnalyInstr?.steps == nil || myAnalyInstr?.steps?.count == 0)
        }
    }
}

#Preview {
    AnalyzedInstructionsView(analyzedInstructions: AnalyzedInstructions.analyInstrExample)
}
