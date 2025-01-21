//
//  CRecipeGroupProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/14/22.
//

import Foundation

public class CRecipeGroupProvider {
    // MARK: - Debug local
    fileprivate var zBug: Bool = false
    // MARK: - Properties
    fileprivate let operationQueue = OperationQueue()
    let recipesUrl: URL
    // MARK: Required Initializer
    init(recipesUrl: URL, completion: @escaping ([CRecipe]?) -> ()) {
        self.recipesUrl = recipesUrl
    
        // Create the operations
        let dataLoadCRecipe = DataLoadOperation(url: self.recipesUrl)
        let crecipeGroupCreate = CRecipeGroupCreateOperation(data: nil)
        let crecipeGroupOut = CRecipeGroupOutputOperation(crecipes: nil, completion: completion)
        

        let operations = [dataLoadCRecipe, crecipeGroupCreate, crecipeGroupOut]
        
        // Add dependencies
        crecipeGroupCreate.addDependency(dataLoadCRecipe)
        crecipeGroupOut.addDependency(crecipeGroupCreate)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        if zBug { print("OperationQueue for CRecipeGroupProvider is launched")}
        
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension CRecipeGroupProvider: Equatable {
    public static func == (lhs: CRecipeGroupProvider, rhs: CRecipeGroupProvider) -> Bool {
        lhs.recipesUrl == rhs.recipesUrl
    }
}

extension CRecipeGroupProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(recipesUrl)
    }
}
