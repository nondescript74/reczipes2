//
//  BuildRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/4/22.
//

import SwiftUI

struct BuildRecipeView: View {

    // MARK: - State
    @State fileprivate var instruction: String = ""
    @State fileprivate var instructions: [String] = []
    // MARK: - Properties
    fileprivate var myRecipe: SRecipe = SRecipe()
    // MARK: - Methods
    fileprivate func addStep() {
        
    }
    var body: some View {
        VStack {
            Text("Add Instructions")
            TextField("First Step", text: $instruction)
            TextField("Second Step", text: $instruction)
            TextField("Third Step", text: $instruction)
            TextField("Fourth Step", text: $instruction)
        }
    }
}

struct BuildRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRecipeView()
    }
}
