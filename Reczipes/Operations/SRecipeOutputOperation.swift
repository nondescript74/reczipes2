//
//  SRecipeOutputOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/21/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol SRecipeOutputOperationDataProvider {
    var srecipe:SRecipe? { get }
}

class SRecipeOutputOperation: SRecipeXOperation {
    // MARK: -  Properties
    fileprivate var inputSRecipe: SRecipe?
    fileprivate var completion: (SRecipe?) -> ()
    // MARK: - Initializer
    init(srecipe: SRecipe?, completion: @escaping (SRecipe?) -> ()) {
        self.completion = completion
        self.inputSRecipe = srecipe
        super.init(srecipe: srecipe)
    }
    
    override func main() {
        
        let srecipez: SRecipe?
        if self.isCancelled { return }
        
        if let inputSRecipe = inputSRecipe {
            srecipez = inputSRecipe
        } else {
            let dataProvider = dependencies
                .filter { $0 is SRecipeOutputOperationDataProvider }
                .first as? SRecipeOutputOperationDataProvider
            srecipez = dataProvider?.srecipe
        }
        
        guard srecipez != nil else { return }
        
        if self.isCancelled { return }
        
        #if DEBUG
        print("SRecipeCreateOperation SRecipe debug description ", srecipez.debugDescription)
        #endif
        
        if isCancelled { return }
        completion(srecipez)
    }
}
