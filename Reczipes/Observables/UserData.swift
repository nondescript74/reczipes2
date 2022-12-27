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

final class UserData: ObservableObject {
    // MARK: - Publisher
    @Published var showFavoritesOnly = false
    @Published var profile = Profile.default
    @Published var vitamins = Vitamins.default
    @Published var nutrition = Nutrition.default
}
