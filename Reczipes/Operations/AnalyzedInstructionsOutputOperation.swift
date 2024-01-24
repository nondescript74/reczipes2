//
//  AnalyzedInstructionsOutputOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import Foundation

protocol AnalyzedInstructionsOutputOperationDataProvider {
    var analyzInstr:AnalyzedInstructions? { get }
}

class AnalyzedInstructionsOutputOperation: AnalyzedInstructionsXOperation {
    // MARK: - Debug local
    private var zBug: Bool = false
    // MARK: -  Properties
    fileprivate var inputAnalyInstr: AnalyzedInstructions?
    fileprivate var completion: (AnalyzedInstructions?) -> ()
    // MARK: - Initializer
    init(analyzedInstr: AnalyzedInstructions?, completion: @escaping (AnalyzedInstructions?) -> ()) {
        self.completion = completion
        self.inputAnalyInstr = analyzedInstr
        super.init(analyzedInstr: analyzedInstr)
    }
    
    override func main() {
        
        let ai: AnalyzedInstructions?
        if self.isCancelled { return }
        
        if let inputAnalyInstr = inputAnalyInstr {
            ai = inputAnalyInstr
        } else {
            let dataProvider = dependencies
                .filter { $0 is AnalyzedInstructionsOutputOperationDataProvider }
                .first as? AnalyzedInstructionsOutputOperationDataProvider
            ai = dataProvider?.analyzInstr
        }
        
        guard ai != nil else { return }
        
        if self.isCancelled { return }
        
        if zBug { print("AnalyzedInstructionsOutputOperation analyzedInstructions debug description ", ai.debugDescription) }
        
        if isCancelled { return }
        completion(ai)
    }
}
