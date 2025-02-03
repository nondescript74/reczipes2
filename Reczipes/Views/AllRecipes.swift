//
//  AllRecipes.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/30/25.
//

import SwiftUI

struct AllRecipes: View {
    
    @EnvironmentObject var aur: AllUserRecipes
    @State private var result: SRecipe?
    let key = UserDefaults.standard.string(forKey: skey) ?? msgs.nk.rawValue
    fileprivate enum msgs: String {
        case nk = "No key"
        case LSRV  = "LoadableSRecipeView"
        case emptyString = ""
        case titleEmpty = "Title is empty"
        case title = "Title: "
        case ext = "Extracted recipe: "
        case ro = "result number of steps obtained is "
        case zero = "0"
        case url = "URL: "
    }
    
    fileprivate var myRecipeUrlsStrings: [String] {
        let strings = Bundle.main.decode([String].self, from: "recipesShippedUrls.json")
        return strings
    }
    
    fileprivate func getExtractedViaUrl(urlString: String) async {
        let getSRecipeUrl = URL(string: "https://api.spoonacular.com/recipes/extract?url=" + urlString + "&analyze=true&forceExtraction=true" + key)
#if DEBUG
        print(msgs.LSRV.rawValue + msgs.url.rawValue + getSRecipeUrl!.absoluteString)
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: getSRecipeUrl!)
            // check for empty array
            if data.isEmpty {
#if DEBUG
                print(msgs.LSRV.rawValue, msgs.ro.rawValue, msgs.zero.rawValue)
#endif
                result = SRecipe.example
            }
            let sRecipe = try JSONDecoder().decode(SRecipe.self, from: data)
            result = sRecipe
            
        } catch  {
#if DEBUG
            let error = error as NSError
            print(msgs.LSRV.rawValue, "error occurred: ", error.localizedDescription)
#endif
            result = SRecipe.example
        }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(myRecipeUrlsStrings, id: \.self) { urlString in
                    RecipeRowNNLView(srecipe: result ?? SRecipe.example, cuisine: "Other")
                        .task {
                            await getExtractedViaUrl(urlString: urlString)
                        }
                }
                
            }
        }
        .environmentObject(aur)
    }
}

#Preview {
    AllRecipes()
        .environmentObject(AllUserRecipes())
}
