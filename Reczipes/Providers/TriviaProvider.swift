//
//  TriviaProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/26/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI
import os

public class TriviaProvider {

    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.Recipes", category: "TriviaProvider")
    // MARK: - Properties
    fileprivate let operationQueue = OperationQueue()
    var triviaUrl: URL
    
    init(triviaUrl: URL, completion: @escaping (Trivia?) -> ()) {
        self.triviaUrl = triviaUrl
    
        // Create the operations
        let dataLoadTrivia = DataLoadOperation(url: self.triviaUrl)
        let triviaCreate = TriviaCreateOperation(data: nil)
        let triviaOut = TriviaOutputOperation(trivia: nil, completion: completion)

        let operations = [dataLoadTrivia, triviaCreate, triviaOut]
        
        // Add dependencies
        triviaCreate.addDependency(dataLoadTrivia)
        triviaOut.addDependency(triviaCreate)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        logger.info("TriviaProvider: OperationQueue for TriviaProvider is launched")
        
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension TriviaProvider: Equatable {
    public static func == (lhs: TriviaProvider, rhs: TriviaProvider) -> Bool {
        lhs.triviaUrl == rhs.triviaUrl
    }
}

extension TriviaProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(triviaUrl)
    }
}
