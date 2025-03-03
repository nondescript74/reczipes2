//
//  OrderingList.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import Foundation
import OSLog

@Observable class OrderingList {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "OrderingList")
    // MARK: - Publisher
    var items = [SectionItem3]()
    var quantities:NSMutableDictionary = NSMutableDictionary()
    // MARK: - Properties
    fileprivate var maxamount = 1.0
    fileprivate var minamount = 0.0

    @MainActor
    var total: Int {
        if items.count > 0 {
            
            logger.info("OrderingList: Total: \(self.items.count)")
            return items.count  //items.reduce(0) { $0 + $1.price }
        } else {
            logger.info( "OrderingList: Total: 0")
            return 0
        }
    }
    // MARK: - Methods
    func change(item: SectionItem3, amount: Double) {
        if items.contains(item) {
            let normalizedAmount = max(maxamount, min(minamount,amount))
            quantities.setValue(normalizedAmount, forKey: item.name)
        }
        logger.info( "OrderingList: quantities changed to : \(self.quantities)")
    }
    
    func add(item: SectionItem3) {
        if !items.contains(item) {  // user may have hit the order button multiple times on the same recipe
            items.append(item)
            self.quantities.setValue(1.0, forKey: item.name)
            logger.info( "OrderingList: added sectionItem3 \(item.name) to items : \(self.items)")
        }
    }
    
    func remove(item: SectionItem3) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            quantities.removeObject(forKey: item.name)
            logger.info( "OrderingList: removed item \(item.name) from items : \(self.items)")
        }
    }
}
