//
//  InMyFridge.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 9/15/22.
//

import Foundation

class MyFridge: ObservableObject {
    @Published var items = [String]()
    //MARK: - Properties
    static let `default` = ["Butter", "Sharp Cheddar", "Feta", "Parmesan", "Eggs", "Milk", "Yoghurt", "Heavy Cream", "Orange Juice", "Frozen corn", "Frozen mixed vegetables", "Frozen peas"]
    fileprivate enum msgs: String {
        case mf = "MyFridge: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Total: "
    }
    
    init() {
        self.items = MyFridge.default
    }
    
    var total: Int {
        if items.count > 0 {
            print(msgs.mf.rawValue + msgs.total.rawValue, items.count)
            return items.count  //items.reduce(0) { $0 + $1.price }
        } else {
            print(msgs.mf.rawValue + msgs.total.rawValue, items.count)
            return 0
        }
    }
    
    func add(item: String) {
        if !items.contains(item) {  // user may have hit the order button multiple times on the same recipe
            items.append(item)
            print(msgs.mf.rawValue + msgs.added.rawValue, item)
        }
    }
    
    func remove(item: String) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            print(msgs.mf.rawValue + msgs.removed.rawValue, item)
            
        }
    }
}
