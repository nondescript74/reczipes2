//
//  CRecipeGroupOutputOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/14/22.
//

import Foundation

protocol CRecipeGroupOutputOperationDataProvider {
    var crecipes:[CRecipe]? { get }
}

class CRecipeGroupOutputOperation: CRecipeGroupXOperation {
    // MARK: - Debug local
    private var zBug:Bool = true
    // MARK: - Properties
    fileprivate var inputcrecipe: [CRecipe]?
    fileprivate let completion: ([CRecipe]?) -> ()
    // MARK: - Initializer
    init(crecipes: [CRecipe]?, completion: @escaping ([CRecipe]?) -> ()) {
        self.completion = completion
        self.inputcrecipe = crecipes
        super.init(cRecipes: crecipes)
    }
    
    override func main() {
        
        let crecipez: [CRecipe]?
        if isCancelled { return }
        
        if let inputcrecipe = inputcrecipe {
            crecipez = inputcrecipe
        } else {
            let dataProvider = dependencies
                .filter { $0 is CRecipeGroupOutputOperationDataProvider }
                .first as? CRecipeGroupOutputOperationDataProvider
            crecipez = dataProvider?.crecipes
        }
        
        guard crecipez != nil else { return }
        
        if self.isCancelled { return }
        
        
        if zBug { print("CRecipeGroupOutputOperation crecipe ", crecipez.debugDescription) }
        
        
        if isCancelled { return }
        completion(crecipez)
    }
}
