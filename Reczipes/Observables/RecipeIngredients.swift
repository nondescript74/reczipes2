//
//  RecipeIngredients.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/26/22.
//

import Foundation

class RecipeIngredients: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var quantities: NSMutableDictionary = NSMutableDictionary()
    
//MARK: - Properties
    fileprivate var maxamount = 1.0
    fileprivate var minamount = 0.0
    
    fileprivate enum msgs: String {
        case ri = "RecipeIngredients: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Total: "
    }
    
    var total: Int {
        if ingredients.count > 0 {
#if DEBUG
            print(msgs.ri.rawValue + msgs.total.rawValue, ingredients.count)
#endif
            return ingredients.count
        } else {
#if DEBUG
            print(msgs.ri.rawValue + msgs.total.rawValue, ingredients.count)
#endif
            return 0
        }
    }
    
    func change(item: Ingredient, amount: Double) {
        if ingredients.contains(item) {
            let normalizedAmount = max(maxamount, min(minamount,amount))
            quantities.setValue(normalizedAmount, forKey: item.name)
        }
#if DEBUG
        print(msgs.ri.rawValue + msgs.changed.rawValue, item.id.description, " ", item.name, " , ", quantities.value(forKey: item.name).debugDescription)
#endif
    }
    
    func add(item: Ingredient) {
        if !ingredients.contains(item) {  // user may have hit the order button multiple times on the same recipe
            ingredients.append(item)
            self.quantities.setValue(1.0, forKey: item.name)
#if DEBUG
            print(msgs.ri.rawValue + msgs.added.rawValue, item.id.description, " ", item.name, " , ", quantities.value(forKey: item.name).debugDescription)
#endif
        }
    }
    
    func remove(item: Ingredient) {
        if let index = ingredients.firstIndex(of: item) {
            ingredients.remove(at: index)
            quantities.removeObject(forKey: item.name)
#if DEBUG
            print(msgs.ri.rawValue + msgs.removed.rawValue, item.id.description, " ", item.name, " , ", quantities.value(forKey: item.name).debugDescription)
#endif
        }
    }
    
}
