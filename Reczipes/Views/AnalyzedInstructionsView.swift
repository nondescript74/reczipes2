//
//  AnalyzedInstructionsView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/19/24.
//

import SwiftUI

struct AnalyzedInstructionsView: View {
    @EnvironmentObject var instructions: AnalyzedInstructionsModel
    init(recipeId: Int) async {
        self.recipeId = recipeId
        await instructions.executeQuery(recipeId: recipeId)
#if DEBUG
        print("AInstrView count:", instructions.result.count)
#endif
    }
    
    fileprivate var recipeId: Int
    
    var body: some View {
        
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
    }
}

//#Preview {
//    AnalyzedInstructionsView(recipeId: SRecipe.example.id)
//}
