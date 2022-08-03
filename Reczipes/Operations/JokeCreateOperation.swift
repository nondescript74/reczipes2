//
//  JokeCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/22/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol JokeCreateOperationDataProvider {
    var data:Data? { get }
}

class JokeCreateOperation: Operation {
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: ((Joke?) -> ())?
    fileprivate var myJoke: Joke?
    fileprivate enum msgs: String {
        case JokeCreateOperation = "JokeCreateOperation: "
        case joke = " joke: "
        case cantDecode = " cannot decode [Joke] from myData "
        case success = "JokeCreateOperation created a Joke "
        case mydata = "myData "
    }
    // MARK: - Initializer
    init(data: Data?, completion: ((Joke?) -> ())? = nil) {
        inputData = data
        self.completion = completion
        super.init()
    }
    
    override func main() {
        
        if self.isCancelled { return }
        let myData: Data?
        
        if let inputData = inputData {
            myData = inputData
        } else {
            let dataProvider = dependencies
                .filter { $0 is JokeCreateOperationDataProvider }
                .first as? JokeCreateOperationDataProvider
            myData = dataProvider?.data
        }
        
        guard myData != nil else { return }
        
        #if DEBUG
        print(msgs.JokeCreateOperation.rawValue + msgs.mydata.rawValue, myData.debugDescription)
        #endif
        
        if self.isCancelled { return }
        
        do {
            let joke = try JSONDecoder().decode(Joke.self, from: myData!)
            myJoke = joke
            #if DEBUG
            print(msgs.JokeCreateOperation.rawValue + msgs.joke.rawValue, joke)
            #endif
        } catch {
            #if DEBUG
            print("Error took place\(error.localizedDescription).")
            #endif
            fatalError(msgs.JokeCreateOperation.rawValue + msgs.cantDecode.rawValue)
        }
        
        #if DEBUG
        print(msgs.success.rawValue, myJoke.debugDescription)
        #endif
        
        if self.isCancelled { return }
        completion?(myJoke)
    }
    
}

extension JokeCreateOperation: JokeOutputOperationDataProvider, JokeXOperationDataProvider {
    var joke: Joke? {
        return myJoke
    }
}
