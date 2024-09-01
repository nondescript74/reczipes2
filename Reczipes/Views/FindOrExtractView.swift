//
//  FindOrExtractView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/24/22.
//

import SwiftUI

struct FindOrExtractView: View {
    // MARK: - EnvironmentObject
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var aur: AllUserRecipes
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
        case entertext = "Enter Recipe URL"
        case extract = "✂️"
        case ingreds = "🍒"
        case enteringreds = "Enter ingredients"
        case cuisine = " as cuisine?"
        case dyw = "Did you want "
        case choose = "Choosing"
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
        case find
    }
    
    fileprivate func getBookSectionNames() -> [String] {
        let namesOfCuisines = Bundle.main.decode([Cuisine].self, from: "cuisines.json").sorted(by: {$0.name < $1.name})
        var names: [String] = []
        namesOfCuisines.forEach {names.append($0.name)}
        return names
    }
    
    // MARK: - Methods
    func getSRecipeGroup() {
        show = Selectors.names
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = getBookSectionNames()[xection]
        sRecipeGroup.findByIngredientsAndCusine(searchString: searchTerm, numberSent: numberNeeded, cuisine: cuisine)
//        sRecipeGroup.getSearched(searchString: searchTerm, numberSent: numberNeeded, cuisine: cuisine)
        endEditing()
    }
    
    func getCRecipeGroup() {
        show = Selectors.find
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = getBookSectionNames()[xection]
        cRecipeGroup.findByIngredientsAndCusine(searchString: searchTerm, numberSent: numberNeeded, cuisine: cuisine)
        endEditing()
    }
    
    func findRandom() {
        show = Selectors.random
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = getBookSectionNames()[xection]
        sRecipeGroup.findByRandom(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
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
//                    HStack {
//                        Text(msgs.choose.rawValue)
//                        Picker(msgs.books.rawValue, selection: $xection) {
//                            let zx = getBookSectionNames().count
//                            ForEach(0..<zx, id: \.self) { index in
//                                Text("\(getBookSectionNames()[index])")
//                            }
//                        }
//                    }
//                    
//                    Divider()
//                    
                    Text(msgs.fr.rawValue).fontWeight(.semibold)
                    
                    HStack(alignment: .center) {
                        SearchBar(text: $searchTerm).padding(.trailing, 5)
                        
                        Button(action: getCRecipeGroup) {
                            Text(msgs.find.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)
//                        
//                        Button(action: getSRecipeGroup) {
//                            Text(msgs.find.rawValue).font(.largeTitle).bold()
//                        }.padding(.trailing, 20)
                        
                        Button(action: findRandom) {
                            Text(msgs.random.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 10)
                    }
                }.padding()
                // Divider()
                VStack {
                    Text(msgs.er.rawValue).fontWeight(.semibold)
                    
                    HStack(alignment: .center) {
                        TextField(msgs.entertext.rawValue, text: $urlString)
                        Button(action: extractRecipe) {
                            Text(msgs.extract.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)
                        
                    }
                }.padding()
                // Divider()
                List   {
                    if show == Selectors.names {
                        ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem3(srecipe: srecipe), cuisine: getBookSectionNames()[xection])
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                    if show == Selectors.find {
                        ForEach(cRecipeGroup.cRecipeGroup) { crecipe in
                            RecipeByIngredientsView(cRecipe: crecipe)
                        }.disabled(cRecipeGroup.cRecipeGroup.isEmpty)
                    }
                    if show == Selectors.random {
                        ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem3(srecipe: srecipe), cuisine: getBookSectionNames()[xection])
                        }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                    }
                    if show == Selectors.extract &&  extractedSRecipe.extractedSRecipe != nil {
                        RecipeRowNNLView(srecipe: extractedSRecipe.extractedSRecipe!, cuisine: getBookSectionNames()[xection])
                    }
                }
            }
            
        }
    }
}

#if DEBUG
struct FindOrExtractView_Previews: PreviewProvider {
    static var previews: some View {
        FindOrExtractView()
            .environmentObject(AllUserRecipes())
            .environmentObject(UserData())
    }
}
#endif
