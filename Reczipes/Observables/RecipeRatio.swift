//
//  RecipeRatio.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/1/22.
//

import Foundation
import OSLog

@Observable class RecipeRatio {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "RecipeRatio")
    var ratio: Double = 1.0
    @MainActor
    func change(amount: Double) {
        ratio = amount
        logger.info("Ratio Changed to: \(amount)")
    }
}
