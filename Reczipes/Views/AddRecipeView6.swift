//
//  AddRecipeView6.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/3/22.
//

import SwiftUI

struct AddRecipeView6: View {
    
    // MARK: - EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    @ObservedObject var sRecipeGroup = WebQueryRecipes()
    // MARK: - Properties
    fileprivate var fileIO = FileIO()
    fileprivate enum msgs: String {
        case AddRecipeView6  = "AddRecipeView6: "
    }
    
    var body: some View {
        Text(AddRecipeView6.msgs.AddRecipeView6.rawValue + "hello, Z")
    }
}

struct AddRecipeView6_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView6()
    }
}
