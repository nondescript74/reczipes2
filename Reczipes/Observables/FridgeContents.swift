//
//  FridgeContents.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/15/22.
//

import Foundation

class FridgeContents: ObservableObject {
    @Published var myContents: NSMutableDictionary
    // MARK: - Initializer
    init() {
        self.myContents = NSMutableDictionary(objects: [0,0,0,0,0,0,0,0,0,0,0,0], forKeys: ["Butter" as NSCopying, "Sharp Cheddar" as NSCopying, "Feta" as NSCopying, "Parmesan" as NSCopying, "Eggs" as NSCopying, "Milk" as NSCopying, "Yoghurt" as NSCopying, "Heavy Cream" as NSCopying, "Orange Juice" as NSCopying, "Frozen corn" as NSCopying, "Frozen mixed vegetables" as NSCopying, "Frozen peas"as NSCopying])
    }
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case fc = "FridgeContents: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Number of fridge items: "
    }
    
    var total: Int {
        let z = myContents.allKeys.count
        if z > 0 {
#if DEBUG
            print(msgs.fc.rawValue + msgs.total.rawValue, z)
#endif
            return z
        } else {
#if DEBUG
            print(msgs.fc.rawValue + msgs.total.rawValue, z)
#endif
            return 0
        }
    }
    // MARK: - Methods
    func change(item: String, amount: Double) {
        if myContents.allKeys.contains(where: {$0 as! String == item}) {
            myContents.setValue(amount, forKey: item)
        }
#if DEBUG
        print(msgs.fc.rawValue + msgs.changed.rawValue, item, " \(String(describing: myContents.value(forKey: item)))")
#endif
    }

    func add(item: String, amount: Double) {
        if !myContents.allKeys.contains(where: {$0 as! String == item}) {  // user may have hit the order button multiple times on the same recipe
            myContents.setValue(amount, forKey: item)
#if DEBUG
            print(msgs.fc.rawValue + msgs.added.rawValue, item, " \(String(describing: myContents.value(forKey: item)))")
#endif
        }
    }

    func remove(item: String) {
        if myContents.allKeys.contains(where: {$0 as! String == item}) {
            myContents.removeObject(forKey: item)
#if DEBUG
            print(msgs.fc.rawValue + msgs.removed.rawValue, item)
#endif
        }
    }
}
