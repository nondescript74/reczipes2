//
//  ExtractSRecipe.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 3/3/25.
//

import SwiftUI
import OSLog

struct ExtractSRecipe: View {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "ExtractSRecipe")
    
    @State private var result: SRecipe?
    @State fileprivate var urlString: String = ""
    @State fileprivate var xectionName: String = "African"
    
    let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "No Key"
    
    
    fileprivate func getExtractedViaUrl() async {
        if urlString.isEmpty {
            logger.info( "url string is empty")
            return
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/extract"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "url", value: urlString))
        queryItems.append(URLQueryItem(name: "analyze", value: "true"))
        queryItems.append(URLQueryItem(name: "forceExtraction", value: "true"))
        urlComponents.queryItems = queryItems
        urlComponents.query! += "\(key)"
        guard urlComponents.url != nil else {
            logger.log( "could not create url , cannot fetch data")
            return
        }
        let getSRecipeUrl = urlComponents.url
        logger.info("getting url \(getSRecipeUrl!.absoluteString)")
        do {
            let (data, _) = try await URLSession.shared.data(from: getSRecipeUrl!)
            // check for empty array
            if data.isEmpty {
                logger.info( "No data returned")
                result = SRecipe.example
            }
            logger.info( "Data returned")
            let sRecipe = try JSONDecoder().decode(SRecipe.self, from: data)
            result = sRecipe
            logger.info( "Decoded data to SRecipe")
            
        } catch  {
            logger.error( "Error occurred: \(error.localizedDescription)")
            result = SRecipe.example
        }
    }
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Paste url here", text: $urlString)
                    Button(
                        action: {
                            Task {await getExtractedViaUrl()}
                        },
                        label: {Text("✂️").font(.largeTitle).bold()}
                    )
                }.padding(.horizontal)
                HStack {
                    Picker("Select", selection: $xectionName) {
                        ForEach(getBookSectionNames(), id: \.self) { bookSection in
                            Text(bookSection).fontWeight(.light)
                        }
                    }
                }
                if result != nil {
                    RecipeRowNNLView(srecipe: result!, cuisine: xectionName)
                }

                AnalyzedInstructionsView(ainstructions: result?.analyzedInstructions ?? [])
            }
            Spacer()
        }
    }
}

#Preview {
    ExtractSRecipe()
}
