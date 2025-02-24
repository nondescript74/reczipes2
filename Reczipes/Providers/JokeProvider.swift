//
//  JokeProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/22/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import os

public class JokeProvider {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.Recipes", category: "JokeProvider")

    // MARK: - Properties
    fileprivate enum msgs: String {
        case jp = "JokeProvider: "
        case jpl = "OperationQueue for JokeProvider is launched"
    }
    fileprivate let operationQueue = OperationQueue()
    var jokeUrl: URL
    
    init(jokeUrl: URL, completion: @escaping (Joke?) -> ()) {
        self.jokeUrl = jokeUrl
        
        // Create the operations
        let dataLoadJoke = DataLoadOperation(url: self.jokeUrl)
        let jokeCreate = JokeCreateOperation(data: nil)
        let jokeOut = JokeOutputOperation(joke: nil, completion: completion)
        
        let operations = [dataLoadJoke, jokeCreate, jokeOut]
        
        // Add dependencies
        jokeCreate.addDependency(dataLoadJoke)
        jokeOut.addDependency(jokeCreate)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        
        logger.info("JokeProvider: OperationQueue for JokeProvider is launched")
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension JokeProvider: Equatable {
    public static func == (lhs: JokeProvider, rhs: JokeProvider) -> Bool {
        lhs.jokeUrl == rhs.jokeUrl
    }
}

extension JokeProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(jokeUrl)
    }
}
