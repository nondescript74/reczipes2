//
//  TriviaCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/26/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol TriviaCreateOperationDataProvider {
    var data:Data? { get }
}

class TriviaCreateOperation: Operation {
    // MARK: Debug local
    private var zBug:Bool = false
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: ((Trivia?) -> ())?
    fileprivate var myTrivia: Trivia?
    fileprivate enum msgs: String {
        case TriviaCreateOperation = "TriviaCreateOperation: "
        case trivia = " trivia: "
        case cantDecode = " cannot decode [Trivia] from myData "
        case success = "TriviaCreateOperation created a Trivia "
        case mydata = "myData "
    }
    // MARK: - Initializer
    init(data: Data?, completion: ((Trivia?) -> ())? = nil) {
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
                .filter { $0 is TriviaCreateOperationDataProvider }
                .first as? TriviaCreateOperationDataProvider
            myData = dataProvider?.data
        }
        
        guard myData != nil else { return }
        

        if zBug { print(msgs.TriviaCreateOperation.rawValue + msgs.mydata.rawValue, myData.debugDescription) }

        
        if self.isCancelled { return }
        
        do {
            let trivia = try JSONDecoder().decode(Trivia.self, from: myData!)
            myTrivia = trivia

            if zBug { print(msgs.TriviaCreateOperation.rawValue + msgs.trivia.rawValue, trivia)}

        } catch {

            print("Error took place\(error.localizedDescription).")

            fatalError(msgs.TriviaCreateOperation.rawValue + msgs.cantDecode.rawValue)
        }
        

        if zBug { print(msgs.success.rawValue, myTrivia.debugDescription)}

        
        if self.isCancelled { return }
        completion?(myTrivia)
    }
    
}

extension TriviaCreateOperation: TriviaOutputOperationDataProvider, TriviaXOperationDataProvider {
    var trivia: Trivia? {
        return myTrivia
    }
}
