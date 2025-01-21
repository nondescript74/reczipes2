//
//  LoadableSRecipeFromUrl.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/21/25.
//

import SwiftUI

struct LoadableSRecipeFromUrl: View {
    fileprivate let zBug: Bool = true
    @State private var result: SRecipe?
    var url: String
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
    }
    
    // MARK: - Methods
    mutating func extractRecipeUsingUrl(url: String) async {
        await getExtractedViaUrl(urlString: url)
#if DEBUG && zBug
        print(msgs.LSRV.rawValue, msgs.ext.rawValue + url + result.title!)
#endif
    }
    
    fileprivate func getExtractedViaUrl(urlString: String) async {
        
        // https://api.spoonacular.com/recipes/extract?url=""&analyze=true&forceExtraction=true + key
        let getSRecipeUrl = URL(string: "https://api.spoonacular.com/recipes/extract?url=" + urlString + "&analyze=true&forceExtraction=true" + key)
#if DEBUG && zBug
        print(msgs.LSRV.rawValue + msgs.url.rawValue + getSRecipeUrl!.absoluteString)
#endif
        do {
            let (data, _) = try await URLSession.shared.data(from: getSRecipeUrl!)
            // check for empty array
            if data.isEmpty {
#if DEBUG && zBug
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
            ScrollView {
                AsyncImage(url: URL(string: (result?.image ?? SectionItem3.example.imageUrl)!)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .accessibility(hidden: false)
                            .accessibilityLabel(Text(result?.title ?? "No title"))
                    } else {
                        ProgressView()
                    }
                }
                AnalyzedInstructionsView(ainstructions: result?.analyzedInstructions ?? [])
                
                
            }
            .task {
                await getExtractedViaUrl(urlString: url)
            }
            .navigationTitle(result?.title ?? "No Recipe Title")
        }
        
    }
}

#Preview {
    LoadableSRecipeFromUrl(url: "https://www.seriouseats.com/vegan-cashew-milk-braised-green-plantains")
}



