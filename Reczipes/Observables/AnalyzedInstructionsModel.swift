//
//  AnalyzedInstructionsModel.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/23/24.
//

import Foundation

class AnalyzedInstructionsModel: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true

    // MARK: - Publisher
    // this is the input
    
    @Published private(set) var result: AnalyzedInstructions? // this is the output.  a single AnalyzedInstructions
    @Published private(set) var isSearching = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case crvm = "AnalyzedInstructionModel: "
    }
    
    @MainActor
    // MARK: - Methods
    func executeQuery(recipeId: Int) async {
        searchTask?.cancel()
        let currentSearchTerm = recipeId
        if currentSearchTerm < 0 {
            result = AnalyzedInstructions.analyInstrExample
            if zBug {print("AIModel: invalid recipeid sent in")}
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
        if zBug {print(msgs.crvm.rawValue + url!.absoluteString)}
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let ai = try JSONDecoder().decode([AnalyzedInstructions].self, from: data)
            if zBug {print(msgs.crvm.rawValue, ai)}
            return ai.first!
        } catch  {
            if zBug {print(msgs.crvm.rawValue + "something wrong")}
            fatalError(msgs.crvm.rawValue + "could not decode AnalyzedInstructions from data")
        }
    }
}
