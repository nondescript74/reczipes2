//
//  RecipeBeingBuilt.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/9/22.
//

import Foundation

class RecipeBeingBuilt: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Initializer
    init() {
        self.srecipe = SRecipe.example
        self.sectionItem = SectionItem.example
        
#if DEBUG
        if zBug {print("RecipeBeingBuilt initialized as SRecipe.example")}
//        if zBug {print("RecipeBeingBuilt restrictions are ", names.description)}
#endif
        
    }
    // MARK: - Publisher
    @Published var srecipe: SRecipe?
    @Published var sectionItem: SectionItem?
    // MARK: - Properties
    
    // MARK: Methods
}
