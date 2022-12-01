//
//  CRecipeDetailView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/18/22.
//

import SwiftUI

struct CRecipeDetailView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    
    // MARK: - Initializer
    init(crecipe: CRecipe, cuisine: String) {
        self.crecipe = crecipe
        self.cuisine = cuisine
    }
    let crecipe: CRecipe
    let cuisine: String

    var body: some View {
        NavigationView {
            NavigationLink("\(crecipe.title)") {
//                    SourceViewer(crecipe: crecipe, cuisine: cuisine)
                }
            
            .navigationTitle("View the recipe")
        }
    }
}

struct CRecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CRecipeDetailView(crecipe: CRecipe.cRecipeExample, cuisine: "Other")
    }
}


