//
//  SRecipeGroupOutputOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 6/9/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation

protocol SRecipeGroupOutputOperationDataProvider {
    var srecipes:[SRecipe]? { get }
}

class SRecipeGroupOutputOperation: SRecipeGroupXOperation {
    // MARK: - Properties
    fileprivate var inputsrecipe: [SRecipe]?
    fileprivate let completion: ([SRecipe]?) -> ()
    // MARK: - Initializer
    init(srecipes: [SRecipe]?, completion: @escaping ([SRecipe]?) -> ()) {
        self.completion = completion
        self.inputsrecipe = srecipes
        super.init(sRecipes: srecipes)
    }
    
    override func main() {
        
        let srecipez: [SRecipe]?
        if isCancelled { return }
        
        if let inputsrecipe = inputsrecipe {
            srecipez = inputsrecipe
        } else {
            let dataProvider = dependencies
                .filter { $0 is SRecipeGroupOutputOperationDataProvider }
                .first as? SRecipeGroupOutputOperationDataProvider
            srecipez = dataProvider?.srecipes
        }
        
        guard srecipez != nil else { return }
        
        if self.isCancelled { return }
        
        #if DEBUG
        print("SRecipeGroupOutputOperation srecipe ", srecipez.debugDescription)
        #endif
        
        if isCancelled { return }
        completion(srecipez)
    }
}
