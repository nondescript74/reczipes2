//
//  TriviaCreateOperation.swift
//  CRecipes
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
        
        #if DEBUG
        print(msgs.TriviaCreateOperation.rawValue + msgs.mydata.rawValue, myData.debugDescription)
        #endif
        
        if self.isCancelled { return }
        
        do {
            let trivia = try JSONDecoder().decode(Trivia.self, from: myData!)
            myTrivia = trivia
            #if DEBUG
            print(msgs.TriviaCreateOperation.rawValue + msgs.trivia.rawValue, trivia)
            #endif
        } catch {
            #if DEBUG
            print("Error took place\(error.localizedDescription).")
            #endif
            fatalError(msgs.TriviaCreateOperation.rawValue + msgs.cantDecode.rawValue)
        }
        
        #if DEBUG
        print(msgs.success.rawValue, myTrivia.debugDescription)
        #endif
        
        if self.isCancelled { return }
        completion?(myTrivia)
    }
    
}

extension TriviaCreateOperation: TriviaOutputOperationDataProvider, TriviaXOperationDataProvider {
    var trivia: Trivia? {
        return myTrivia
    }
}
