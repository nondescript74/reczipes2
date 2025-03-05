//
//  FindSRecipes.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 3/3/25.
//

import SwiftUI
import OSLog

struct FindSRecipes: View {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "FindSRecipes")
    
    let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "No Key"
    
    // MARK: - Environment
    @Environment(UserData.self) private var userData
    @Environment(AllUserRecipes.self) private var aur
    
    @State private var result: [SRecipe]?
    @State fileprivate var searchTerm: String = ""
    @State fileprivate var xectionName: String = "African"
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    fileprivate func findSRecipes() async {
        if searchTerm.isEmpty {
            logger.info( "search term is empty")
            return
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/complexSearch"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "query", value: searchTerm))
        queryItems.append(URLQueryItem(name: "number", value: userData.profile.numberOfRecipes.rawValue.description))
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
                result = [SRecipe.example]
            }
            logger.info( "Data returned")
            let sRecipes = try JSONDecoder().decode([SRecipe].self, from: data)
            result = sRecipes
            logger.info( "Decoded data to SRecipes")
            
        } catch  {
            logger.error( "Error occurred: \(error.localizedDescription)")
            result = [SRecipe.example]
        }
    }
    
    func findRandom() async {
        logger.info( "findRandom called")
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/random"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "number", value: userData.profile.numberOfRecipes.rawValue.description))
        urlComponents.queryItems = queryItems
        urlComponents.query! += "\(key)"
        guard urlComponents.url != nil else {
            logger.log( "could not create url , cannot fetch data")
            return
        }
        let getRandomSRecipes = urlComponents.url
        logger.info("getting url \(getRandomSRecipes!.absoluteString)")
        do {
            let (data, _) = try await URLSession.shared.data(from: getRandomSRecipes!)
            // check for empty array
            if data.isEmpty {
                logger.info( "No data returned")
                result = [SRecipe.example]
            }
            logger.info( "Data returned")
            let sRecipes = try JSONDecoder().decode([SRecipe].self, from: data)
            result = sRecipes
            logger.info( "Decoded data to SRecipes")
            
        } catch  {
            logger.error( "Error occurred: \(error.localizedDescription)")
            result = [SRecipe.example]
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                SearchBar(text: $searchTerm)
                
                Button(
                    action: {
                        Task {await findSRecipes()}
                    },
                    label: {Text("?").font(.largeTitle).bold()}
                )
                Button(
                    action: {
                        Task {await findRandom()}
                    },
                    label: {Text("🤷🏽‍♂️").font(.largeTitle).bold()}
                )
            }
            HStack {
                Picker("Select", selection: $xectionName) {
                    ForEach(getBookSectionNames(), id: \.self) { bookSection in
                        Text(bookSection).fontWeight(.light)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    FindSRecipes()
}
