//
//  AnalyzedInstructionsProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import Foundation

public class AnalyzedInstructionsProvider {
    // MARK: - Debug local
    private var zBug: Bool = false
    // MARK: - Properties
    fileprivate let operationQueue = OperationQueue()
    var analyzedInstructionsUrl: URL
    // MARK: Required Initializer
    init(analyzedInstructionsUrl: URL, completion: @escaping (AnalyzedInstructions?) -> ()) {
        self.analyzedInstructionsUrl = analyzedInstructionsUrl
    
        // Create the operations
        let dataLoadAnalyzedInstructions = DataLoadOperation(url: self.analyzedInstructionsUrl)
        let recipeCreate = AnalyzedInstructionsCreateOperation(data: nil)
        let recipeOut = AnalyzedInstructionsOutputOperation(analyzedInstr: nil, completion: completion)

        let operations = [dataLoadAnalyzedInstructions, recipeCreate, recipeOut]
        
        // Add dependencies
        recipeCreate.addDependency(dataLoadAnalyzedInstructions)
        recipeOut.addDependency(recipeCreate)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        if zBug { print("OperationQueue for AnalyzedInstructionsProvider url is ", analyzedInstructionsUrl.absoluteString) }
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension AnalyzedInstructionsProvider: Equatable {
    public static func == (lhs: AnalyzedInstructionsProvider, rhs: AnalyzedInstructionsProvider) -> Bool {
        lhs.analyzedInstructionsUrl == rhs.analyzedInstructionsUrl
    }
}

extension AnalyzedInstructionsProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(analyzedInstructionsUrl)
    }
}
