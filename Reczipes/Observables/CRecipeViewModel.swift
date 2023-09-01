//
//  CRecipeViewModel.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/18/22.
//

import SwiftUI

class CRecipeViewModel: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Initializer

    // MARK: - Publisher
    @Published var id: String = ""  // this is the input
    
    @Published private(set) var result: [SRecipe] = [] // this is the output.  a single SRECIPE in the array
    @Published private(set) var isSearching = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case crvm = "CRecipeViewModel: "
    }
    
    @MainActor
    // MARK: - Methods
    func executeQuery() async {
        searchTask?.cancel()
        let currentSearchTerm = id.trimmingCharacters(in: .whitespaces)
        if currentSearchTerm.isEmpty {
            result = []
            isSearching = false
        }
        else {
            searchTask = Task {
                isSearching = true
                result = await searchSRecipe(matching: id)
                if !Task.isCancelled {
                    isSearching = false
                }
            }
        }
    }
    
    private func searchSRecipe(matching id: String) async -> [SRecipe] {
        let escapedSearchTerm = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        let url = URL(string: "https://api.spoonacular.com/recipes/\(escapedSearchTerm)/information?includeNutrition=false" + key)!
        if zBug {print(msgs.crvm.rawValue + url.description)}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let srecipe = try JSONDecoder().decode(SRecipe.self, from: data)
            if zBug {print(msgs.crvm.rawValue, srecipe)}
            return[srecipe]
        } catch  {
            if zBug {print(msgs.crvm.rawValue + "something wrong")}
            return []
        }
    }
}
