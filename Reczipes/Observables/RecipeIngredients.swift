//
//  RecipeIngredients.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/26/22.
//

import Foundation

class RecipeIngredients: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    
//MARK: - Properties

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
    
    /*
     var name: String
     var id: Int64
     var localizedName: String?
     var image: String?
     */
    
    func change(item: Ingredient, name: String, id: Int64, localnmae: String, image: String) {
        if ingredients.contains(item) {
            ingredients.remove(at: 1)
            ingredients.append(item)
        }
#if DEBUG
        print(msgs.ri.rawValue + msgs.changed.rawValue, item.id.description, " ", item.name)
#endif
    }
    
    func add(item: Ingredient) {
        if !ingredients.contains(item) {  // user may have hit the order button multiple times on the same recipe
            ingredients.append(item)
#if DEBUG
            print(msgs.ri.rawValue + msgs.added.rawValue, item.id.description, " ", item.name)
#endif
        }
    }
    
    func remove(item: Ingredient) {
        if let index = ingredients.firstIndex(of: item) {
            ingredients.remove(at: index)
#if DEBUG
            print(msgs.ri.rawValue + msgs.removed.rawValue, item.id.description, " ", item.name)
#endif
        }
    }
    
}
