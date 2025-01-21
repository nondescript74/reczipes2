//
//  TriviaOutputOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/26/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol TriviaOutputOperationDataProvider {
    var trivia:Trivia? { get }
}

class TriviaOutputOperation: TriviaXOperation {
    // MARK: Debug local
    fileprivate var zBug: Bool = false
    // MARK: -  Properties
    fileprivate var inputTrivia: Trivia?
    fileprivate var completion: (Trivia?) -> ()
    // MARK: - Initializer
    init(trivia: Trivia?, completion: @escaping (Trivia?) -> ()) {
        self.completion = completion
        self.inputTrivia = trivia
        super.init(trivia: trivia)
    }
    
    override func main() {
        
        let triviaz: Trivia?
        if self.isCancelled { return }
        
        if let inputTrivia = inputTrivia {
            triviaz = inputTrivia
        } else {
            let dataProvider = dependencies
                .filter { $0 is TriviaOutputOperationDataProvider }
                .first as? TriviaOutputOperationDataProvider
            triviaz = dataProvider?.trivia
        }
        
        guard triviaz != nil else { return }
        
        if self.isCancelled { return }
        

        if zBug { print("TriviaCreateOperation Trivia debug description ", triviaz.debugDescription)}

        
        if isCancelled { return }
        completion(triviaz)
    }
}

extension TriviaOutputOperation: @unchecked Sendable {
     
}
