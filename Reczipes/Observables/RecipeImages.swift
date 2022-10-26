//
//  RecipeImages.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/26/22.
//

import Foundation

class RecipeImages: ObservableObject {
    @Published var images: [ImageSaved] = []
    
//MARK: - Properties
    fileprivate var maxamount = 1.0
    fileprivate var minamount = 0.0
    
    fileprivate enum msgs: String {
        case ri = "RecipeImages: "
        case added = "Added: "
        case removed = "Removed: "
        case changed = "Changed: "
        case total = "Total: "
    }
    
    var total: Int {
        if images.count > 0 {
#if DEBUG
            print(msgs.ri.rawValue + msgs.total.rawValue, images.count)
#endif
            return images.count
        } else {
#if DEBUG
            print(msgs.ri.rawValue + msgs.total.rawValue, images.count)
#endif
            return 0
        }
    }
    
    func change(item: ImageSaved) {
        if images.contains(item) {
            self.remove(item: item)
            self.add(item: item)
        }
#if DEBUG
        print(msgs.ri.rawValue + msgs.changed.rawValue, item.recipeuuid.description)
#endif
    }
    
    func add(item: ImageSaved) {
        if !images.contains(item) {  // user may have hit the order button multiple times on the same recipe
            images.append(item)
#if DEBUG
            print(msgs.ri.rawValue + msgs.added.rawValue, item.recipeuuid.description)
#endif
        }
    }
    
    func remove(item: ImageSaved) {
        if let index = images.firstIndex(of: item) {
            images.remove(at: index)
#if DEBUG
            print(msgs.ri.rawValue + msgs.removed.rawValue, item.recipeuuid.description)
#endif
        }
    }
    
}
