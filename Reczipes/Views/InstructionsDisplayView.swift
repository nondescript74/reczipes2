//
//  InstructionsDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import SwiftUI

struct InstructionsDisplayView: View {
//    @ObservedObject var analyInstr = WebQueryRecipes()
    // MARK: - Initializer
    init(analyzedInstructions: AnalyzedInstructions) {
        self.myAnalyInst = analyzedInstructions
    }
    // MARK: - Properties
    private var myAnalyInst: AnalyzedInstructions?
    
    var body: some View {
        VStack {
            Text(myAnalyInst?.name ?? "Analyzed Instructions with no name yet").disabled(myAnalyInst == nil)
            AnalyzedInstructionsView(analyzedInstructions: myAnalyInst ?? AnalyzedInstructions.analyInstrExample).disabled(myAnalyInst == nil)
        }
    }
}

struct InstructionsDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsDisplayView( analyzedInstructions: AnalyzedInstructions.analyInstrExample)}
}
