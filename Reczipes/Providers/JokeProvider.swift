//
//  JokeProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/22/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation

public class JokeProvider {
    // MARK: - Debug local
    private var zBug:Bool = false
    // MARK: - Properties
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
        
#if DEBUG
        if zBug { print("OperationQueue for JokeProvider is launched")}
#endif
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
