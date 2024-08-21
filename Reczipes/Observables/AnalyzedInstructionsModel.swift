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
    
    // MARK: - Initializer
    init() {
        result = AnalyzedInstructions(analyzedInstructions: [])
    }
    
    // MARK: - Publisher
    @Published private(set) var result: AnalyzedInstructions // this is the output.  a single AnalyzedInstructions
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
            if zBug { print(msgs.aim.rawValue, msgs.ni.rawValue + result.analyzedInstructions.count.description, msgs.ns.rawValue + (result.analyzedInstructions.first?.steps.count.description ?? "no steps in first instruction"))}
#endif
            if !Task.isCancelled {
                isSearching = false
            }
        }
        
    }
    //    func executeQuery(recipeId: Int) async {
    //        searchTask?.cancel()
    //        let currentSearchTerm = recipeId
    //        if currentSearchTerm < 0 || currentSearchTerm == nil {
    //            result = AnalyzedInstructions.analyInstrExample
    //#if DEBUG
    //            if zBug {print(msgs.aim.rawValue + msgs.irid.rawValue)}
    //#endif
    //            isSearching = false
    //        }
    //        else {
    //            searchTask = Task {
    //                isSearching = true
    //                result = await searchAnalyzedInstructions(matching: recipeId)
    //#if DEBUG
    //                if zBug { print(msgs.aim.rawValue, msgs.ro.rawValue, result.setOfAnalyzedInstruction.count as Any, result.setOfAnalyzedInstruction.first?.steps   .count as Any)}
    //#endif
    //                if !Task.isCancelled {
    //                    isSearching = false
    //                }
    //            }
    //        }
    //    }
    
    private func searchAnalyzedInstructions(matching id: Int) async -> AnalyzedInstructions {
        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
        
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?" + key)
#if DEBUG
        if zBug {print(msgs.aim.rawValue + url!.absoluteString)}
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let ai = try JSONDecoder().decode(AnalyzedInstructions.self, from: data)
#if DEBUG
            if zBug {print(msgs.aim.rawValue, ai)}
            if zBug {print(msgs.noai.rawValue, ai.analyzedInstructions.count > 1)}
#endif
            return ai
        } catch  {
            fatalError(msgs.aim.rawValue + msgs.cnd.rawValue)
        }
    }
}
