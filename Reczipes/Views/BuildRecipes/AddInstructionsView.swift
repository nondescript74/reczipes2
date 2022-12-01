//
//  AddInstructionsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/26/22.
//

import SwiftUI

struct AddInstructionsView: View {
    // MARK: - Local Debug
    fileprivate var zBug: Bool = false
    // MARK: - Environment Variables
    @EnvironmentObject var instructions: RecipeInstructions
    // MARK: - State
    @State fileprivate var myText: String = ""
    // MARK: - Properties
    
    // MARK: - Methods
    fileprivate func addInstr() {
        instructions.add(item: Instruction(id: Int64.random(in: 1..<myMaxInt64), text: myText))
        myText = ""
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter", text: $myText)
                    Button("Add " + myText, action: { addInstr()})
                        .buttonStyle(.bordered)
                }.padding(.bottom)
                
                VStack {
                    Text("Added Instructions")
                    ForEach(instructions.instructions, id: \.self) { instr in
                        Text(instr.text)
                    }
                }
            }.padding()
            .navigationTitle("Instructions")
        }
    }
    
}

struct AddInstructionsView_Previews: PreviewProvider {
    static let recipeInstr = RecipeInstructions()
    static var previews: some View {
        AddInstructionsView()
            .environmentObject(recipeInstr)
    }
}
