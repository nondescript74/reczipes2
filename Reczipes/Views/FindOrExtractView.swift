//
//  FindOrExtractView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/24/22.
//

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
        logger.info("extractRecipe called")
        if xectionName == "" {return}
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
                        Text(msgs.er.rawValue).fontWeight(.semibold)
                        
                        Picker("Select", selection: $xectionName) {
                            ForEach(getBookSectionNames(), id: \.self) { bookSection in
                                Text(bookSection).fontWeight(.light)
                            }
                        }
                        
                    }
                    
                    HStack(alignment: .center) {
                        TextField(msgs.entertext.rawValue, text: $urlString)
                        
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
