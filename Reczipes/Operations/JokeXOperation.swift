//
//  JokeXOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/10/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol JokeXOperationDataProvider {
    var joke: Joke? { get }
}

class JokeXOperation: Operation {
    var filterOutput: Joke?
    fileprivate let _filterInput: Joke?
    
    init(joke: Joke?) {
        _filterInput = joke
        super.init()
    }
    
    var filterInput: Joke? {
        var joke: Joke?
        if let inputJoke = _filterInput {
            joke = inputJoke
        } else if let dataProvider = dependencies
            .filter({ $0 is JokeXOperationDataProvider })
            .first as? JokeXOperationDataProvider {
            joke = dataProvider.joke
        }
        
        print(joke.debugDescription)
        
        
        filterOutput = joke
        return filterOutput
    }
}

extension JokeXOperation: JokeXOperationDataProvider {
    var joke: Joke? {
        return filterOutput
    }
}
