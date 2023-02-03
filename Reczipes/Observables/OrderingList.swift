//
//  OrderingList.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import Foundation

class OrderingList: ObservableObject {
    @Published var items = [SectionItem]()
    @Published var quantities:NSMutableDictionary = NSMutableDictionary()
    //MARK: - Properties
    fileprivate var maxamount = 1.0
    fileprivate var minamount = 0.0
    fileprivate enum msgs: String {
        case orderingList = "OrderingList: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Total: "
    }
    @MainActor
    var total: Int {
        if items.count > 0 {
#if DEBUG
            print(msgs.orderingList.rawValue + msgs.total.rawValue, items.count)
#endif
            return items.count  //items.reduce(0) { $0 + $1.price }
        } else {
#if DEBUG
            print(msgs.orderingList.rawValue + msgs.total.rawValue, items.count)
#endif
            return 0
        }
    }
    
    func change(item: SectionItem, amount: Double) {
        if items.contains(item) {
            let normalizedAmount = max(maxamount, min(minamount,amount))
            quantities.setValue(normalizedAmount, forKey: item.name)
        }
#if DEBUG
        print(msgs.orderingList.rawValue + msgs.changed.rawValue, item.id.description, " ", item.name, " , ", quantities.value(forKey: item.name).debugDescription)
#endif
    }
    
    func add(item: SectionItem) {
        if !items.contains(item) {  // user may have hit the order button multiple times on the same recipe
            items.append(item)
            self.quantities.setValue(1.0, forKey: item.name)
#if DEBUG
            print(msgs.orderingList.rawValue + msgs.added.rawValue, item.id.description, " ", item.name, " , ", quantities.value(forKey: item.name).debugDescription)
#endif
        }
    }
    
    func remove(item: SectionItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            quantities.removeObject(forKey: item.name)
#if DEBUG
            print(msgs.orderingList.rawValue + msgs.removed.rawValue, item.id.description, " ", item.name, " , ", quantities.value(forKey: item.name).debugDescription)
#endif
        }
    }
}


