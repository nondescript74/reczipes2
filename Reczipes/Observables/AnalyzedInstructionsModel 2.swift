//
//  AnalyzedInstructionsModel 2.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 8/26/24.
//

import Foundation
import Combine

class AnalyzedInstructionsModel: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    
    // MARK: - Publisher
    @Published private(set) var result: [AnalyzedInstructions] = [AnalyzedInstructions(name: "Dummy", steps: [])] // this is the output.  a single AnalyzedInstructions
    @Published private(set) var isSearching: Bool = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case aim = "AnalyzedInstructionModel: "
        case ro = "result number of steps obtained is "
        case irid = "invalid recipeid sent in"
        case cnd = "could not decode AnalyzedInstructions from data"
        case nk = "No Api Key"
        case noai = "Number of Analyzed Instructions is greater than 1? "
        case ni = "Number of instructions: "
        case ns = "Number of steps in first instruction: "
    }
    
    @MainActor
    // MARK: - Methods
    func executeQuery(recipeId: Int) async {
        searchTask?.cancel()
        searchTask = Task {
            isSearching = true
            result = await searchAnalyzedInstructions(matching: recipeId)
#if DEBUG
            if zBug { print(msgs.aim.rawValue, msgs.ni.rawValue + (result.first?.name ?? "no name on first instruction"))}
#endif
            if !Task.isCancelled {
                isSearching = false
            }
        }
        
    }
    
    private func searchAnalyzedInstructions(matching id: Int) async -> [AnalyzedInstructions] {
        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
        
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?" + key)
#if DEBUG
        if zBug {print(msgs.aim.rawValue + url!.absoluteString)}
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            // check for empty array
            if data.isEmpty {
#if DEBUG
                if zBug {print(msgs.aim.rawValue, msgs.ro.rawValue, "0")}
#endif
                return [AnalyzedInstructions(name: "No instructions", steps: [])]
            }
            let ai = try JSONDecoder().decode([AnalyzedInstructions].self, from: data)
#if DEBUG
            if zBug {print(msgs.aim.rawValue, ai.first!.name)}
#endif
            return ai
        } catch  {
#if DEBUG
            let error = "\(msgs.noai.rawValue) \(id)"
            print(error)
#endif
            return [AnalyzedInstructions(name: "No instructions", steps: [])]
        }
    }
}
