//
//  SRecipeGroupXOperation.swift
//  CRecipes
//
//  Created by Zahirudeen Premji on 12/10/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol SRecipeGroupXOperationDataProvider {
    var srecipes: [SRecipe]? { get }
}

class SRecipeGroupXOperation: Operation {
    var filterOutput: [SRecipe]?
    fileprivate let _filterInput: [SRecipe]?
    
    init(sRecipes: [SRecipe]?) {
        _filterInput = sRecipes
        super.init()
    }
    
    var filterInput: [SRecipe]? {
        var image: [SRecipe]?
        if let inputImage = _filterInput {
            image = inputImage
        } else if let dataProvider = dependencies
            .filter({ $0 is SRecipeGroupXOperationDataProvider })
            .first as? SRecipeGroupXOperationDataProvider {
            image = dataProvider.srecipes
        }
        filterOutput = image
        return image
    }
}

extension SRecipeGroupXOperation: SRecipeGroupXOperationDataProvider {
    var srecipes: [SRecipe]? {
        return filterOutput
    }
}
