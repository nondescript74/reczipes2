//
//  CRecipeGroupXOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/14/22.
//

import Foundation
import SwiftUI

protocol CRecipeGroupXOperationDataProvider {
    var crecipes: [CRecipe]? { get }
}

class CRecipeGroupXOperation: Operation {
    var filterOutput: [CRecipe]?
    fileprivate let _filterInput: [CRecipe]?
    
    init(cRecipes: [CRecipe]?) {
        _filterInput = cRecipes
        super.init()
    }
    
    var filterInput: [CRecipe]? {
        var image: [CRecipe]?
        if let inputImage = _filterInput {
            image = inputImage
        } else if let dataProvider = dependencies
            .filter({ $0 is CRecipeGroupXOperationDataProvider })
            .first as? CRecipeGroupXOperationDataProvider {
            image = dataProvider.crecipes
        }
        filterOutput = image
        return image
    }
}

extension CRecipeGroupXOperation: CRecipeGroupXOperationDataProvider {
    var crecipes: [CRecipe]? {
        return filterOutput
    }
}
