//
//  UserData.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 5/12/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import Combine
import SwiftUI
import OSLog

@Observable final class UserData {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "UserData")
    // MARK: - Initializer
    init() {
        self.profile = Profile.default
        self.nutrition = Nutrition.default
        self.vitamins = Vitamins.default
        self.showFavoritesOnly = false
        logger.info( "UserData initialized")
    }
    // MARK: - Publisher
    var showFavoritesOnly: Bool
    var profile: Profile
    var vitamins: Vitamins
    var nutrition: Nutrition
}
