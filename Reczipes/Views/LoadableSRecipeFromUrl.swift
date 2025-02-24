//
//  LoadableSRecipeFromUrl.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/21/25.
//

import SwiftUI

struct LoadableSRecipeFromUrl: View {
    @State private var result: SRecipe?
    var urlstr: String
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
                Text(result?.title ?? "No Recipe Title").font(.headline)
                    .padding()
                AsyncImage(url: URL(string: (result?.image ?? SectionItem3.example.imageUrl)!)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    } else {
                        ProgressView()
                    }
                }
                AnalyzedInstructionsView(ainstructions: result?.analyzedInstructions ?? [])
            }
            .task {
                await getExtractedViaUrl(urlString: urlstr)
            }
        }
    }
}

#Preview {
    LoadableSRecipeFromUrl(urlstr: "https://www.seriouseats.com/vegan-cashew-milk-braised-green-plantains")
}



