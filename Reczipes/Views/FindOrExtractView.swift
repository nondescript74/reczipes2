//
//  FindOrExtractView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/24/22.
//

import Foundation
import SwiftUI
import OSLog

struct FindOrExtractView: View {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "FindOrExtractView")
    let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "No Key"
    
    // MARK: - EnvironmentObject
    @Environment(UserData.self) private var userData
    @Environment(AllUserRecipes.self) private var aur
    // MARK: - ObservedObject
    var sRecipeGroup = WebQueryRecipes()
    var extractedSRecipe = WebQueryRecipes()
    // MARK: - Properties
    fileprivate enum msgs: String {
        case fr = "Find or Extract"
        case books = "Recipe Books"
        case find = "?"
        case random = "🤷🏽‍♂️"
        case er = "Extract Recipe"
        case entertext = "Enter Recipe URL to extract"
        case extract = "✂️"
        case ingreds = "🍒"
        case enteringreds = "Enter ingredients"
        case cuisine = " as cuisine?"
        case dyw = "Did you want "
        case choose = "Choose cuisine"
    }
    fileprivate var cuisine = ""
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    // MARK: - State
    @State fileprivate var strExtract: String = ""
    @State fileprivate var ingredsString: String = ""
    @State fileprivate var xectionName: String = "African"
    @State fileprivate var recipeRequested: Bool = false
    @State fileprivate var searchTerm: String = ""
    @State fileprivate var show: Selectors = .notyet
    @State fileprivate var result: SRecipe?
    
    // MARK: - Properties
    enum Selectors {
        case notyet
        case extract
        case names
        case random
        case find
    }
    
    // MARK: - Methods
    fileprivate func getExtractedViaUrl() async {
        if strExtract.isEmpty {
            logger.info( "string for extracting is empty")
            return
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/extract"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "url", value: strExtract))
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
    
    func getSRecipeGroup() {
        logger.info("getSRecipeGroup called.  Searchterm supplied: \(searchTerm)")
        if xectionName == "" {return}
        show = Selectors.names
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = xectionName
        sRecipeGroup.complexSearch(searchString: searchTerm, numberSent: numberNeeded, cuisine: cuisine)
        endEditing()
    }
    
    func findRandom() {
        logger.info("findRandom called")
        if xectionName == "" {return}
        show = Selectors.random
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = xectionName
        sRecipeGroup.findByRandom(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
        endEditing()
    }
    
    func findRandomAsync() async {
        logger.info(#function)
    }
    
    //    func extractRecipe() {
    //        logger.info("extractRecipe called")
    //        if xectionName == "" {return}
    //        show = Selectors.extract
    //        extractedSRecipe.findExtracted(urlString: urlString)
    //        urlString = ""
    //        endEditing()
    //    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack(alignment: .center) {
                        SearchBar(text: $searchTerm)
                        
                        Button(action: getSRecipeGroup) {
                            Text(msgs.find.rawValue).font(.largeTitle).bold()
                        }
                        Button(action: findRandom) {
                            Text(msgs.random.rawValue).font(.largeTitle).bold()
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("Cuisine").fontWeight(.semibold)
                        
                        Picker("Select", selection: $xectionName) {
                            ForEach(getBookSectionNames(), id: \.self) { bookSection in
                                Text(bookSection).fontWeight(.light)
                            }
                        }
                        
                    }
                    VStack {
                        TextField("Enter URL", text: $strExtract)
                        
                        HStack {
                            Button {
                                Task {
                                    await getExtractedViaUrl()
                                    strExtract = ""
                                    show = Selectors.extract
                                    logger.info("Fetched data, extraction url reset")
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.largeTitle)
                                        .padding(.bottom, 4)
                                    Text("Get Recipe")
                                }
                                
                            }.disabled(strExtract.isEmpty)
                                .buttonStyle(.bordered)
                         }
                        
                    }
                }
                
                if show == Selectors.names {
                    List {
                        ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem3(srecipe: srecipe), cuisine: xectionName)
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                }
                if show == Selectors.random {
                    List {
                        ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem3(srecipe: srecipe), cuisine: xectionName)
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                }
                if show == Selectors.extract && result != nil {
                    RecipeRowNNLView(srecipe: result!, cuisine: xectionName)
                }
//                if show == Selectors.extract && extractedSRecipe.extractedSRecipe != nil {
//                    RecipeRowNNLView(srecipe: extractedSRecipe.extractedSRecipe!, cuisine: xectionName)
//                    
//                }
                Spacer()
                
            }
            .navigationTitle(Text("Find Recipes"))
        }
        .environment(aur)
        .environment(userData)
    }
}


struct FindOrExtractView_Previews: PreviewProvider {
    static var previews: some View {
        FindOrExtractView()
            .environment(AllUserRecipes())
            .environment(UserData())
    }
}
