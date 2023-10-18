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
    init(srecipe: SRecipe?, sectionItem: SectionItem?) {
        self.srecipe = srecipe ?? SRecipe.example
        self.sectionItem = sectionItem ?? SectionItem.example
#if DEBUG
        if srecipe != nil {
            if zBug {print(msgs.rbb.rawValue + msgs.sias.rawValue, srecipe!.instructions ?? msgs.ni.rawValue)}
        } else {
            if zBug {print(msgs.rbb.rawValue + msgs.nosias.rawValue)}
        }
        
        if sectionItem != nil {
            if zBug {print(msgs.rbb.rawValue + msgs.siias.rawValue, sectionItem!.name)}
        } else {
            if zBug {print(msgs.rbb.rawValue + msgs.nosiias.rawValue)}
        }
#endif
    }
    // MARK: - Alternate initializer
    init() {
        self.srecipe = SRecipe.example
        self.sectionItem = SectionItem.example
        
#if DEBUG
        if zBug {print(msgs.rbb.rawValue + msgs.siae.rawValue + msgs.comma.rawValue + msgs.siiae.rawValue)}
#endif
        
    }
    // MARK: - Publisher
    @Published var srecipe: SRecipe?
    @Published var sectionItem: SectionItem?
    // MARK: - Properties
    fileprivate enum msgs: String {
        case rbb = "RecipeBeingBuilt: "
        case sias = "srecipe initialized as supplied: "
        case nosias = "no srecipe supplied so initialized as srecipe.Example"
        case siias = "sectionItem initialized as supplied: "
        case nosiias = "no sectionItem supplied so initialized as sectionItem.Example"
        case siae = "srecipe initialized as SRecipe.example"
        case siiae = "sectionItem initialized as SectionItem.example"
        case comma = " ,"
        case ni = "no instructions"
    }
    
    // MARK: Methods
}
