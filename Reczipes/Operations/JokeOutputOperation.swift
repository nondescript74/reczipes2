//
//  JokeOutputOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/22/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
protocol JokeOutputOperationDataProvider {
    var joke:Joke? { get }
}

class JokeOutputOperation: JokeXOperation {
    // MARK: - Debug local
    private var zBug: Bool = false
    // MARK: -  Properties
    fileprivate enum msgs: String {
        case jo = "JokeOutputOperation: "
        case jdd = " Joke debug description "
    }
    
    fileprivate var inputJoke: Joke?
    fileprivate var completion: (Joke?) -> ()
    // MARK: - Initializer
    init(joke: Joke?, completion: @escaping (Joke?) -> ()) {
        self.completion = completion
        self.inputJoke = joke
        super.init(joke: joke)
    }
    
    override func main() {
        
        let jokez: Joke?
        if self.isCancelled { return }
        
        if let inputJoke = inputJoke {
            jokez = inputJoke
        } else {
            let dataProvider = dependencies
                .filter { $0 is JokeOutputOperationDataProvider }
                .first as? JokeOutputOperationDataProvider
            jokez = dataProvider?.joke
        }
        
        guard jokez != nil else { return }
        
        if self.isCancelled { return }
        
        #if DEBUG
        if zBug {print(msgs.jo.rawValue + msgs.jdd.rawValue + jokez.debugDescription)}
        #endif
        
        if isCancelled { return }
        completion(jokez)
    }
}
