//
//  AnalyzedInstructionsModel.swift
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
    @Published private(set) var result: [AnalyzedInstructions] = [AnalyzedInstructions(name: "Dummy", steps: [])] //this is the output, an AnalyzedInstructions array
    @Published private(set) var isSearching: Bool = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case aim = "AnalyzedInstructionModel: "
        case ex = "execute called "
        case ro = "result number of steps obtained is "
        case rid = "recipeId: "
        case irid = "invalid recipeid sent in"
        case url = "url: "
        case cnd = "could not decode AnalyzedInstructions from data"
        case nk = "No Api Key"
        case noai = "Number of Analyzed Instructions is greater than 1? "
        case ni = "Number of instructions: "
        case ns = "Number of steps in first instruction: "
        case dbgmsg = "No name supplied for instruction"
        case noinst = "No instructions"
        case emptyStr = "Empty string"
        case zero = "0"
        case url1 = "https://api.spoonacular.com/recipes/"
        case url2 = "/analyzedInstructions?"
        case thekey = "+apiKey"
    }
    
    @MainActor
    // MARK: - Methods
    func executeQuery(recipeId: Int) async {
        searchTask?.cancel()
        searchTask = Task {
            isSearching = true
            result = await searchAnalyzedInstructions(matching: recipeId)
#if DEBUG
            if zBug { print(msgs.aim.rawValue, msgs.ex.rawValue + msgs.rid.rawValue + recipeId.description)}  //(result.first?.name ?? "no name on first instruction"))}
#endif
            if !Task.isCancelled {
                isSearching = false
            }
        }
    }
    
    private func searchAnalyzedInstructions(matching id: Int) async -> [AnalyzedInstructions] {
        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
        
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?" + key)
        let urldbg = URL(string: msgs.url1.rawValue + "\(id)" + msgs.url2.rawValue + msgs.thekey.rawValue)
#if DEBUG
        if zBug {print(msgs.aim.rawValue + msgs.url.rawValue + urldbg!.absoluteString)}
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            // check for empty array
            if data.isEmpty {
#if DEBUG
                if zBug {print(msgs.aim.rawValue, msgs.ro.rawValue, msgs.zero.rawValue)}
#endif
                return [AnalyzedInstructions(name: msgs.noinst.rawValue, steps: [])]
            }
            let ai = try JSONDecoder().decode([AnalyzedInstructions].self, from: data)
#if DEBUG
            
            if ai.first?.name == msgs.emptyStr.rawValue {
                if zBug {print(msgs.aim.rawValue, msgs.dbgmsg.rawValue)}
            } else {
                if zBug {print(msgs.aim.rawValue, ai.first!.name)}
            }
#endif
            return ai
        } catch  {
#if DEBUG
            let error = "\(msgs.noai.rawValue) \(id)"
            print(error)
#endif
            return [AnalyzedInstructions(name: msgs.noinst.rawValue, steps: [])]
        }
    }
}
