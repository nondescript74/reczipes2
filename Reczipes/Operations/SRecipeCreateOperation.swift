//
//  SRecipeCreateOperation.swift
//  CRecipes
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
        
        #if DEBUG
        print(msgs.SRecipeCreateOperation.rawValue + msgs.mydata.rawValue, myData.debugDescription)
        #endif
        
        if self.isCancelled { return }
        
        do {
            let recipe = try JSONDecoder().decode(SRecipe.self, from: myData!)
            myRecipe = recipe
            #if DEBUG
            print(msgs.SRecipeCreateOperation.rawValue + msgs.recipe.rawValue, recipe)
            #endif
        } catch {
            #if DEBUG
            print("Error took place\(error.localizedDescription).")
            #endif
            fatalError(msgs.SRecipeCreateOperation.rawValue + msgs.cantDecode.rawValue)
        }
        
        #if DEBUG
        print(msgs.success.rawValue, myRecipe.debugDescription)
        #endif
        
        if self.isCancelled { return }
        completion?(myRecipe)
    }
    
}

extension SRecipeCreateOperation: SRecipeOutputOperationDataProvider, SRecipeXOperationDataProvider {
    var srecipe: SRecipe? {
        return myRecipe
    }
}
