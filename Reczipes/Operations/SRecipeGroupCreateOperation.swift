//
//  SRecipeGroupCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 6/9/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol SRecipeGroupCreateOperationDataProvider {
    var data:Data? { get }
}

class SRecipeGroupCreateOperation: Operation {
    // MARK: - Debug local
    private var zBug: Bool = false
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: (([SRecipe]?) -> ())?
    fileprivate var mySRecipes: [SRecipe]?
    // MARK: - Initializer
    init(data: Data?, completion: (([SRecipe]?) -> ())? = nil) {
        inputData = data
        self.completion = completion
        super.init()
    }
    
    override func main() {
        
        if self.isCancelled { return }
        let myData: Data?
        
        if let inputData = inputData {
            myData = inputData
        } else {
            let dataProvider = dependencies
                .filter { $0 is SRecipeGroupCreateOperationDataProvider }
                .first as? SRecipeGroupCreateOperationDataProvider
            myData = dataProvider?.data
        }
        
        guard myData != nil else { return }
        
        if self.isCancelled { return }
        
        do {
            let srecipes = try JSONDecoder().decode(SRecipeGroup.self, from: myData!)
            if srecipes.results != nil {
                mySRecipes = srecipes.results
            } else if srecipes.recipes != nil {
                mySRecipes = srecipes.recipes
            }
            
            
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        
        
        if zBug { print("SRecipeGroupCreateOperation created an array of SRecipes", mySRecipes!.count) }
          
        
        if self.isCancelled { return }
        completion?(mySRecipes)
    }
    
}

extension SRecipeGroupCreateOperation: SRecipeGroupOutputOperationDataProvider, SRecipeGroupXOperationDataProvider       {
    var srecipes: [SRecipe]? {
        return mySRecipes
    }
}
