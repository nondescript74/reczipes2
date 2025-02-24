//
//  RecipeRatio.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/1/22.
//

import Foundation
import os

class RecipeRatio: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.Reczipes", category: "RecipeRatio")
    @Published var ratio: Double = 1.0
    @MainActor
    func change(amount: Double) {
        ratio = amount
        logger.info("RecipeRatio: Changed to: \(amount)")
    }
}
