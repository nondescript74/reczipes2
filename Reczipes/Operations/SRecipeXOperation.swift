//
//  SRecipeXOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/27/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol SRecipeXOperationDataProvider {
    var srecipe: SRecipe? { get }
}

class SRecipeXOperation: Operation {
    var filterOutput: SRecipe?
    fileprivate let _filterInput: SRecipe?
    
    init(srecipe: SRecipe?) {
        _filterInput = srecipe
        super.init()
    }
    
    var filterInput: SRecipe? {
        var srecipe: SRecipe?
        if let inputSRecipe = _filterInput {
            srecipe = inputSRecipe
        } else if let dataProvider = dependencies
            .filter({ $0 is SRecipeXOperationDataProvider })
            .first as? SRecipeXOperationDataProvider {
            srecipe = dataProvider.srecipe
        }
        #if DEBUG
        print(srecipe.debugDescription)
        #endif
        
        filterOutput = srecipe
        return filterOutput
    }
}

extension SRecipeXOperation: SRecipeXOperationDataProvider {
    var srecipe: SRecipe? {
        return filterOutput
    }
}
