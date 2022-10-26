//
//  RecipeInstructions.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/26/22.
//

import Foundation


class RecipeInstructions: ObservableObject {
    @Published var instructions: [Instruction] = []
    
//MARK: - Properties
    fileprivate var maxamount = 1.0
    fileprivate var minamount = 0.0
    
    fileprivate enum msgs: String {
        case ri = "RecipeInstructions: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Total: "
    }
    
    var total: Int {
        if instructions.count > 0 {
#if DEBUG
            print(msgs.ri.rawValue + msgs.total.rawValue, instructions.count)
#endif
            return instructions.count
        } else {
#if DEBUG
            print(msgs.ri.rawValue + msgs.total.rawValue, instructions.count)
#endif
            return 0
        }
    }
    
    func change(item: Instruction) {
        if instructions.contains(item) {
            self.remove(item: item)
            self.add(item: item)
        }
#if DEBUG
        print(msgs.ri.rawValue + msgs.changed.rawValue, item.id.description, " ", item.text)
#endif
    }
    
    func add(item: Instruction) {
        if !instructions.contains(item) {  // user may have hit the order button multiple times on the same recipe
            instructions.append(item)
#if DEBUG
            print(msgs.ri.rawValue + msgs.added.rawValue, item.id.description, " ", item.text)
#endif
        }
    }
    
    func remove(item: Instruction) {
        if let index = instructions.firstIndex(of: item) {
            instructions.remove(at: index)
#if DEBUG
            print(msgs.ri.rawValue + msgs.removed.rawValue, item.id.description, " ", item.text)
#endif
        }
    }
    
}
