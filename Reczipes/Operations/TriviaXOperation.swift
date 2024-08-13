//
//  TriviaXOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/10/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol TriviaXOperationDataProvider {
    var trivia: Trivia? { get }
}

class TriviaXOperation: Operation {
    var filterOutput: Trivia?
    fileprivate let _filterInput: Trivia?
    
    init(trivia: Trivia?) {
        _filterInput = trivia
        super.init()
    }
    
    var filterInput: Trivia? {
        var trivia: Trivia?
        if let inputTrivia = _filterInput {
            trivia = inputTrivia
        } else if let dataProvider = dependencies
            .filter({ $0 is TriviaXOperationDataProvider })
            .first as? TriviaXOperationDataProvider {
            trivia = dataProvider.trivia
        }
        
        print(trivia.debugDescription)
        
        
        filterOutput = trivia
        return filterOutput
    }
}

extension TriviaXOperation: @unchecked Sendable {
     
}

extension TriviaXOperation: TriviaXOperationDataProvider {
    var trivia: Trivia? {
        return filterOutput
    }
}

