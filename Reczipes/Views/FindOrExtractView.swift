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
    
    // MARK: - EnvironmentObject
    @Environment(UserData.self) private var userData
    @Environment(AllUserRecipes.self) private var aur
    // MARK: - ObservedObject
    var sRecipeGroup = WebQueryRecipes()
    var extractedSRecipe = WebQueryRecipes()
    // MARK: - Properties
    fileprivate enum msgs: String {
        case books = "Recipe Books"
        case find = "?"
        case random = "🤷🏽‍♂️"
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
    @State fileprivate var searchTerm: String = ""
    @State fileprivate var strRandom: String = ""
    @State fileprivate var ingredsString: String = ""
    @State fileprivate var xectionName: String = "African"
    @State fileprivate var recipeRequested: Bool = false
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
        sRecipeGroup.findByRandom(searchString: strRandom, numberSent: numberNeeded, tags: cuisine)
        strRandom = ""
        endEditing()
    }
//    
//    
//    func extractRecipe() {
//        logger.info("extractRecipe called, url is: \(strExtract)")
//        if xectionName == "" {return}
//        show = Selectors.extract
//        extractedSRecipe.findExtracted(urlString: strExtract)
//        searchTerm = ""
//        endEditing()
//    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            LazyVStack {
                HStack {
                    Text("Cuisine").fontWeight(.semibold)
                    
                    Picker("Select", selection: $xectionName) {
                        ForEach(getBookSectionNames(), id: \.self) { bookSection in
                            Text(bookSection).fontWeight(.light)
                        }
                    }
                    
                }.padding()
                VStack {
                    HStack(alignment: .center) {
                        SearchBar(text: $searchTerm)
                        
                        Button(action: getSRecipeGroup) {
                            Text(msgs.find.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing)
                    }
                    
                    HStack(alignment: .center) {
                        SearchBar(text: $strRandom)
                    
                        Button(action: findRandom) {
                            Text(msgs.random.rawValue).font(.largeTitle).bold()
                                .padding(.trailing)
                        }
                    }
                }
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
