//
//  AnalyzedInstructionsXOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import Foundation

protocol AnalyzedInstructionsXOperationDataProvider {
    var analyzInstr: AnalyzedInstructions? { get }
}


class AnalyzedInstructionsXOperation: Operation {
        var filterOutput: AnalyzedInstructions?
        fileprivate let _filterInput: AnalyzedInstructions?
        
        init(analyzedInstr: AnalyzedInstructions?) {
            _filterInput = analyzedInstr
            super.init()
        }
        
        var filterInput: AnalyzedInstructions? {
            var ai: AnalyzedInstructions?
            if let inputAnalyInstr = _filterInput {
                ai = inputAnalyInstr
            } else if let dataProvider = dependencies
                .filter({ $0 is AnalyzedInstructionsXOperationDataProvider })
                .first as? AnalyzedInstructionsXOperationDataProvider {
                ai = dataProvider.analyzInstr
            }
            
            print(ai.debugDescription)
            
            
            filterOutput = ai
            return filterOutput
        }
    }

extension AnalyzedInstructionsXOperation: AnalyzedInstructionsXOperationDataProvider {
    var analyzInstr: AnalyzedInstructions? {
        return filterOutput
    }
}
