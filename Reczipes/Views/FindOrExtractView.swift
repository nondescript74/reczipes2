//
//  FindOrExtractView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/24/22.
//

import SwiftUI

struct FindOrExtractView: View {
    // MARK: - EnvironmentObject
//    @EnvironmentObject var fileMgr: FileMgr
//    @EnvironmentObject var addedRecipes: AddedRecipes
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    // MARK: - ObservedObject
    @ObservedObject var sRecipeGroup = WebQueryRecipes()
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    @ObservedObject var cRecipeGroup = WebQueryRecipes()
    // MARK: - Properties
    fileprivate enum msgs: String {
        case fr = "Find Recipe"
        case books = "Recipe Books"
        case find = "?"
        case random = "🤷🏽‍♂️"
        case er = "Extract Recipe"
        case ingred = "Find By Ingredients"
        case entertext = "Enter Recipe URL"
        case extract = "✂️"
        case ingreds = "🍒"
        case enteringreds = "Enter ingredients"
    }
    fileprivate var cuisine = ""
    // MARK: - State
    @State private var urlString: String = ""
    @State fileprivate var ingredsString: String = ""
    @State private var xection: Int = 0
    @State private var recipeRequested: Bool = false
    @State fileprivate var searchTerm: String = ""
    @State private var show: Selectors = .notyet
    // MARK: - Properties
    enum Selectors {
        case notyet
        case extract
        case names
        case random
        case ingred
    }
    
    // MARK: - Methods
    
    func getSRecipeGroup() {
        show = Selectors.names
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = getBookSectionNames()[xection]
        sRecipeGroup.getSearched(searchString: searchTerm, numberSent: numberNeeded, cuisine: cuisine)
        endEditing()
    }
    
    func findRandom() {
        show = Selectors.random
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = getBookSectionNames()[xection]
        sRecipeGroup.findByRandom(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
        endEditing()
    }
    
    func findByIngredients() {
        show = Selectors.ingred
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = getBookSectionNames()[xection]
        cRecipeGroup.findByIngredientsAndCusine(searchString: ingredsString, numberSent: numberNeeded, cuisine: cuisine)
        endEditing()
    }
    
    func extractRecipe() {
        show = Selectors.extract
        extractedSRecipe.findExtracted(urlString: urlString)
        urlString = ""
        endEditing()
    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text(msgs.fr.rawValue).font(.largeTitle).bold()
                    
                    Picker(msgs.books.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getBookSectionNames()[index])")
                        }
                    }
                    
                    HStack(alignment: .center) {
                        SearchBar(text: $searchTerm).padding(.trailing, 5)
                        
                        Button(action: getSRecipeGroup) {
                            Text(msgs.find.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)
                        
                        Button(action: findRandom) {
                            Text(msgs.random.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 10)
                    }
                }.padding()
                Divider()
                VStack {
                    Text(msgs.er.rawValue).font(.largeTitle).bold()
                    
                    HStack(alignment: .center) {
                        TextField(msgs.entertext.rawValue, text: $urlString)
                        Button(action: extractRecipe) {
                            Text(msgs.extract.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)
                        
                    }
                }.padding()
                Divider()
                VStack {
                    Text(msgs.ingred.rawValue).font(.largeTitle).bold()
                    
                    HStack(alignment: .center) {
                        TextField(msgs.enteringreds.rawValue, text: $ingredsString)
                        Button(action: findByIngredients) {
                            Text(msgs.extract.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)
                        
                    }
                }.padding()
                List   {
                    if show == Selectors.names {
                        ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: srecipe), cuisine: getBookSectionNames()[xection])
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                    if show == Selectors.random {
                        ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: srecipe), cuisine: getBookSectionNames()[xection])
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                    if show == Selectors.extract {
                        RecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: extractedSRecipe.extractedSRecipe ?? SRecipe.example), cuisine: (extractedSRecipe.extractedSRecipe?.cuisines?.first ?? BookSection.example.name)! )
                    }
                    if show == Selectors.ingred {
                        ForEach(cRecipeGroup.cRecipeGroup) { crecipe in
                            CRecipeRowView(crecipe: crecipe, cuisine: getBookSectionNames()[xection])
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                }
            }
            
        }
    }
}

struct FindOrExtractView_Previews: PreviewProvider {
    static var previews: some View {
        FindOrExtractView()
    }
}
