//
//  SRecipeCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/21/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol SRecipeCreateOperationDataProvider {
    var data:Data? { get }
}

class SRecipeCreateOperation: Operation {
    // MARK: - Debug local
    private var zBug: Bool = true
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: ((SRecipe?) -> ())?
    fileprivate var myRecipe: SRecipe?
    fileprivate enum msgs: String {
        case SRecipeCreateOperation = "SRecipeCreateOperation: "
        case recipe = " recipe: "
        case cantDecode = " cannot decode [SRecipe] from myData "
        case success = "SRecipeCreateOperation created a SRecipe "
        case mydata = "myData "
    }
    // MARK: - Initializer
    init(data: Data?, completion: ((SRecipe?) -> ())? = nil) {
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
                .filter { $0 is SRecipeCreateOperationDataProvider }
                .first as? SRecipeCreateOperationDataProvider
            myData = dataProvider?.data
        }
        
        guard myData != nil else { return }
        
        
        if zBug { print(msgs.SRecipeCreateOperation.rawValue + msgs.mydata.rawValue, myData.debugDescription)}
        
        
        if self.isCancelled { return }
        
        do {
            let recipe = try JSONDecoder().decode(SRecipe.self, from: myData!)
            myRecipe = recipe
            
            if zBug { print(msgs.SRecipeCreateOperation.rawValue + msgs.recipe.rawValue, recipe)}
            
        } catch {
            
            if zBug { print("Error took place\(error.localizedDescription).") }
            
            fatalError(msgs.SRecipeCreateOperation.rawValue + msgs.cantDecode.rawValue)
        }
        
        
        if zBug { print(msgs.success.rawValue, myRecipe.debugDescription) }
        
        
        if self.isCancelled { return }
        completion?(myRecipe)
    }
    
}

extension SRecipeCreateOperation: @unchecked Sendable {
     
}

extension SRecipeCreateOperation: SRecipeOutputOperationDataProvider, SRecipeXOperationDataProvider {
    var srecipe: SRecipe? {
        return myRecipe
    }
}
