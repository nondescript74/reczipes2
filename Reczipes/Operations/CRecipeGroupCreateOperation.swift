//
//  CRecipeGroupCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/14/22.
//

import Foundation
import SwiftUI

protocol CRecipeGroupCreateOperationDataProvider {
    var data:Data? { get }
}

class CRecipeGroupCreateOperation: Operation {
    // MARK: - Debug local
    private var zBug:Bool = false
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: (([CRecipe]?) -> ())?
    fileprivate var myCRecipes: [CRecipe]?
    // MARK: - Initializer
    init(data: Data?, completion: (([CRecipe]?) -> ())? = nil) {
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
                .filter { $0 is CRecipeGroupCreateOperationDataProvider }
                .first as? CRecipeGroupCreateOperationDataProvider
            myData = dataProvider?.data
        }
        
        guard myData != nil else { return }
        
        if self.isCancelled { return }
        
        do {
            let crecipes = try JSONDecoder().decode(CRecipeGroup.self, from: myData!)
            if crecipes.results != nil {
                myCRecipes = crecipes.results
            } else {
                fatalError("No CRecipes???")
            }
            
            
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        
        
        if zBug { print("CRecipeGroupCreateOperation created an array of CRecipes", myCRecipes!.count) }
          
        
        if self.isCancelled { return }
        completion?(myCRecipes)
    }
    
}

extension CRecipeGroupCreateOperation: CRecipeGroupOutputOperationDataProvider, CRecipeGroupXOperationDataProvider       {
    var crecipes: [CRecipe]? {
        return myCRecipes
    }
}

