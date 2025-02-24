//
//  SRecipeGroupProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 6/9/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import os

public class SRecipeGroupProvider {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.Recipes", category: "SRecipeGroupProvider")

    
    // MARK: - Properties
    fileprivate let operationQueue = OperationQueue()
    let recipesUrl: URL
    // MARK: Required Initializer
    init(recipesUrl: URL, completion: @escaping ([SRecipe]?) -> ()) {
        self.recipesUrl = recipesUrl
    
        // Create the operations
        let dataLoadSRecipe = DataLoadOperation(url: self.recipesUrl)
        let recipeGroupCreate = SRecipeGroupCreateOperation(data: nil)
        let recipeGroupOut = SRecipeGroupOutputOperation(srecipes: nil, completion: completion)

        let operations = [dataLoadSRecipe, recipeGroupCreate, recipeGroupOut]
        
        // Add dependencies
        recipeGroupCreate.addDependency(dataLoadSRecipe)
        recipeGroupOut.addDependency(recipeGroupCreate)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        logger.info("SRecipeGroupProvider : OperationQue SRecipeGroupProvider is launched")
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension SRecipeGroupProvider: Equatable {
    public static func == (lhs: SRecipeGroupProvider, rhs: SRecipeGroupProvider) -> Bool {
        lhs.recipesUrl == rhs.recipesUrl
    }
}

extension SRecipeGroupProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(recipesUrl)
    }
}
