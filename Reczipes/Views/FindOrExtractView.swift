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
    // MARK: - Properties
    fileprivate enum msgs: String {
        case fr = "Find or Extract"
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
        case choose = "Choose cuisine"
    }
    fileprivate var cuisine = ""
    // MARK: - State
    @State fileprivate var urlString: String = ""
    @State fileprivate var ingredsString: String = ""
    @State fileprivate var xectionName: String = "African"
    @State fileprivate var recipeRequested: Bool = false
    @State fileprivate var searchTerm: String = ""
    @State fileprivate var show: Selectors = .notyet
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
#if DEBUG
        print(msgs.find.rawValue, " getSRecipeGroup called.  Searchterm supplied: \(searchTerm)", " find by ingredients and cuisine")
#endif
        if xectionName == "" {return}
        show = Selectors.names
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = xectionName
        sRecipeGroup.complexSearch(searchString: searchTerm, numberSent: numberNeeded, cuisine: cuisine)
        endEditing()
    }
    
    func findRandom() {
#if DEBUG
        print(msgs.find.rawValue, " findRandom called. executing find by random")
#endif
        if xectionName == "" {return}
        show = Selectors.random
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        let cuisine = xectionName
        sRecipeGroup.findByRandom(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
        endEditing()
    }
    
    func extractRecipe() {
#if DEBUG
        print(msgs.find.rawValue, " extractRecipe called. executing extract")
#endif
        if xectionName == "" {return}
        show = Selectors.extract
        extractedSRecipe.findExtracted(urlString: urlString)
        urlString = ""
        endEditing()
#if DEBUG
        print(msgs.extract.rawValue, urlString)
#endif
    }
    
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
                    Text(msgs.er.rawValue).fontWeight(.semibold)
                    
                    HStack(alignment: .center) {
                        TextField(msgs.entertext.rawValue, text: $urlString)
                        
                        HStack {
                            Picker("Select", selection: $xectionName) {
                                ForEach(getBookSectionNames(), id: \.self) { bookSection in
                                    Text(bookSection).fontWeight(.light)
                                }
                            }
                        }
                        
                        Button(action: extractRecipe) {
                            Text(msgs.extract.rawValue).font(.largeTitle).bold()
                        }
                    }
                    .padding([.leading, .trailing])
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
                if show == Selectors.extract && extractedSRecipe.extractedSRecipe != nil {
                    RecipeRowNNLView(srecipe: extractedSRecipe.extractedSRecipe!, cuisine: xectionName)
                    
                }
                Spacer()
                
            }
            .navigationTitle(Text(msgs.fr.rawValue))
        }
        .environmentObject(aur)
        .environmentObject(userData)
    }
}


struct FindOrExtractView_Previews: PreviewProvider {
    static var previews: some View {
        FindOrExtractView()
            .environmentObject(AllUserRecipes())
            .environmentObject(UserData())
    }
}
