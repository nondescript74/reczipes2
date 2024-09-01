//
//  TwoStepFetchModel.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 8/29/24.
//

import Foundation

class TwoStepSRecipeFetchModel: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Initializer

    // MARK: - Publisher
    @Published var id: String = ""  // this is the input
    @Published var groupOfRecipeIds: Array<Int> = []  // first step fetches all the ids, second step uses the ids to get array of SRecipe
    @Published private(set) var result: [SRecipe] = [] // this is the output.  a single SRECIPE in the array
    @Published private(set) var isSearching = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case tssrfm = "TwoStepSRecipeFetchModel: "
        case wrong = "Something wrong with data fetch or decode"
    }
    fileprivate enum urlThings: String {
        case baseUrl = "https://api.spoonacular.com/recipes/"
        case endurl = "/information?"
    }
    fileprivate enum queries: String {
        case query = "query="
        case numberDesired = "&number="
        case ingredients = "ingredients="
        case nutritionFalse = "includeNutrition=false"
        case nutritionTrue = "includeNutrition=true"
        case recipeInfo = "&addRecipeInformation=true"
        case extract = "url="
        case trivia, joke = ""
        case cuisine = "&cuisine="
        case tags = "&tags="
        case anlyztrue = "&analyze=true"
    }
    @MainActor
    // MARK: - Methods
    func executeQuery() async {
        searchTask?.cancel()
//        let currentSearchTerm = id.trimmingCharacters(in: .whitespaces)
//        if currentSearchTerm.isEmpty {
        if id.isEmpty {
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
        if zBug {print(msgs.tssrfm.rawValue + url.description)}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let srecipe = try JSONDecoder().decode(SRecipe.self, from: data)
            if zBug {print(msgs.tssrfm.rawValue, srecipe)}
            return[srecipe]
        } catch  {
            if zBug {print(msgs.tssrfm.rawValue + "something wrong")}
            return []
        }
    }
}

