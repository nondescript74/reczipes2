//
//  AnalyzedInstructionsModel.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/23/24.
//

import Foundation

class AnalyzedInstructionsModel: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false

    // MARK: - Publisher
    @Published private(set) var result: AnalyzedInstructions? // this is the output.  a single AnalyzedInstructions
    @Published private(set) var isSearching = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case aim = "AnalyzedInstructionModel: "
    }
    
    @MainActor
    // MARK: - Methods
    func executeQuery(recipeId: Int) async {
        searchTask?.cancel()
        let currentSearchTerm = recipeId
        if currentSearchTerm < 0 {
            result = AnalyzedInstructions.analyInstrExample
            if zBug {print("aim: invalid recipeid sent in")}
            isSearching = false
        }
        else {
            searchTask = Task {
                isSearching = true
                result = await searchAnalyzedInstructions(matching: recipeId)
                if zBug { print("AIModel: result obtained", result?.steps?.count as Any)}
                if !Task.isCancelled {
                    isSearching = false
                }
            }
        }
    }
    
    
    private func searchAnalyzedInstructions(matching id: Int) async -> AnalyzedInstructions {
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?" + key)
        if zBug {print(msgs.aim.rawValue + url!.absoluteString)}
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let ai = try JSONDecoder().decode([AnalyzedInstructions].self, from: data)
            if zBug {print(msgs.aim.rawValue, ai)}
            return ai.first!
        } catch  {
            if zBug {print(msgs.aim.rawValue + "something wrong")}
            fatalError(msgs.aim.rawValue + "could not decode AnalyzedInstructions from data")
        }
    }
}
