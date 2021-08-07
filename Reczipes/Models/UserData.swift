//
//  UserData.swift
//  CRecipes
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
import CoreData

final class UserData: ObservableObject {
    // MARK: - Environment
    //@Environment(\.managedObjectContext) var managedObjectContext
    
    @Published var showFavoritesOnly = false
    @Published var profile = Profile.default
    @Published var vitamins = Vitamins.default
    @Published var nutrition = Nutrition.default
}

struct UserData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, Z, Nothing to preview here")
    }
}
