//
//  RecipeSteps.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/30/22.
//

import Foundation

class RecipeSteps: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    @Published var recipeSteps: [Step] = []
    
//MARK: - Properties

    fileprivate enum msgs: String {
        case rs = "RecipeSteps: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Total: "
    }
}
