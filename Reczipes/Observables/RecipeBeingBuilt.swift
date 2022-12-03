//
//  RecipeBeingBuilt.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/9/22.
//

import Foundation

class RecipeBeingBuilt: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Initializer
    init() {
        self.srecipe = SRecipe.example
    }
    // MARK: - Publisher
    @Published var srecipe: SRecipe?
    // MARK: - Properties
    func saveToFile() {
         
    }

}
