//
//  RecipeRatio.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/1/22.
//

import Foundation

class RecipeRatio: ObservableObject {
    @Published var ratio: Double = 1.0
    //MARK: - Properties
    fileprivate enum msgs: String {
        case rr = "RecipeRatio: "
        case changed = "Changed to: "
    }
    
    func change(amount: Double) {
        ratio = amount.rounded()
        print(msgs.rr.rawValue + msgs.changed.rawValue, ratio.description)
    }
}




