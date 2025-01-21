//
//  GetSRecipeWithInformation.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 9/1/24.
//

import Foundation

class SRecipeWithInfo: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    
    // MARK: - Publisher
    @Published private(set) var result: SRecipe = SRecipe.example //this is the output, an SRecipe
    @Published private(set) var isSearching: Bool = false
    
    // MARK: - Properties
    private var searchTask: Task<Void, Never>?
    fileprivate enum msgs: String {
        case srwi = "SRecipeWithInfo: "
        case ex = "execute called "
        case ext = "Extracting recipe using url: "
        case ro = "result number of steps obtained is "
        case rid = "recipeId: "
        case irid = "invalid recipeid sent in"
        case url = "url: "
        case cnd = "could not decode SRecipe from data"
        case nk = "No Api Key"
        case emptyStr = "Empty string"
        case zero = "0"
        case url1 = "https://api.spoonacular.com/recipes/"
        case url2 = "/analyzedInstructions?"
        case thekey = "+apiKey"
    }
    
    @MainActor
    // MARK: - Methods
    func extractRecipeUsingUrl(url: String) async {
        searchTask?.cancel()
        searchTask = Task {
            isSearching = true
            await getExtractedViaUrl(urlString: url)
#if DEBUG
            if zBug { print(msgs.srwi.rawValue, msgs.ext.rawValue + url + result.title!)}
#endif
        }
    }
    
    fileprivate func getExtractedViaUrl(urlString: String) async {
        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
        // https://api.spoonacular.com/recipes/extract?url=""&analyze=true&forceExtraction=true + key
        let getSRecipeUrl = URL(string: "https://api.spoonacular.com/recipes/extract?url=" + urlString + "&analyze=true&forceExtraction=true" + key)
#if DEBUG
        if zBug {print(msgs.srwi.rawValue + msgs.url.rawValue + getSRecipeUrl!.absoluteString)}
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: getSRecipeUrl!)
            // check for empty array
            if data.isEmpty {
#if DEBUG
                if zBug {print(msgs.srwi.rawValue, msgs.ro.rawValue, msgs.zero.rawValue)}
#endif
                result = SRecipe.example
            }
            let sRecipe = try JSONDecoder().decode(SRecipe.self, from: data)
#if DEBUG
            
            if sRecipe.title == msgs.emptyStr.rawValue {
                if zBug {print(msgs.srwi.rawValue, msgs.emptyStr.rawValue)}
            } else {
                if zBug {print(msgs.srwi.rawValue, sRecipe.title!)}
            }
#endif
            result = sRecipe
        } catch  {
#if DEBUG
            let error = error as NSError
            print(msgs.srwi.rawValue, msgs.ex.rawValue + error.localizedDescription)
#endif
            result = SRecipe.example
        }
        
        
    }
    
    
    func executeQuery(recipeId: Int) async {
        searchTask?.cancel()
        searchTask = Task {
            isSearching = true
            result = await searchSRecipe(matching: recipeId)
#if DEBUG
            if zBug { print(msgs.srwi.rawValue, msgs.ex.rawValue + msgs.rid.rawValue + result.title!)}  //
#endif
            if !Task.isCancelled {
                isSearching = false
            }
        }
    }
    
    
    private func searchSRecipe(matching id: Int) async -> SRecipe {
        let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
        // https://api.spoonacular.com/recipes/{id}/information
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/information?" + key)
        let urldbg = URL(string: msgs.url1.rawValue + "\(id)" + msgs.url2.rawValue + msgs.thekey.rawValue)
#if DEBUG
        if zBug {print(msgs.srwi.rawValue + msgs.url.rawValue + urldbg!.absoluteString)}
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            // check for empty array
            if data.isEmpty {
#if DEBUG
                if zBug {print(msgs.srwi.rawValue, msgs.ro.rawValue, msgs.zero.rawValue)}
#endif
                return SRecipe.example
            }
            let sRecipeWithInfo = try JSONDecoder().decode(SRecipe.self, from: data)
#if DEBUG
            
            if sRecipeWithInfo.title == msgs.emptyStr.rawValue {
                if zBug {print(msgs.srwi.rawValue, msgs.emptyStr.rawValue)}
            } else {
                if zBug {print(msgs.srwi.rawValue, sRecipeWithInfo.title!)}
            }
#endif
            return sRecipeWithInfo
        } catch  {
#if DEBUG
            let error = "\(msgs.cnd.rawValue) \(id)"
            print(error)
#endif
            return SRecipe.example
        }
    }
}

