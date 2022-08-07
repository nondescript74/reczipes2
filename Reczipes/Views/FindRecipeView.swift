//
//  FindRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/5/22.
//

import SwiftUI

struct FindRecipeView: View {
    // MARK: - EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    @ObservedObject var sRecipeGroup = WebQueryRecipes()
    // MARK: - Properties
    fileprivate var fileIO = FileIO()
    fileprivate enum msgs: String {
        case fr = "Find Recipe"
        case books = "Recipe Books"
        case find = "?"
        case random = "🤷🏽‍♂️"
    }
    // MARK: - State
    @State private var urlString: String = ""
    @State private var xection: Int = 0
    @State private var recipeRequested: Bool = false
    @State fileprivate var searchTerm: String = ""
    @State private var show: Selectors = .notyet
    // MARK: - Properties
    enum Selectors {
        case notyet
        case names
        case random
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
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            GeometryReader(content: { geometry in
                VStack {
                    Text(msgs.fr.rawValue).font(.largeTitle).bold()
                    HStack(alignment: .center) {
                        SearchBar(text: $searchTerm).padding(.trailing, 5)
                        Button(action: getSRecipeGroup) {
                            Text(msgs.find.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)
                        Button(action: findRandom) {
                            Text(msgs.random.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 10)

                    }
                    
                    Picker(msgs.books.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getBookSectionNames()[index])")
                        }
                    }
                    
                    
                    List   {
                        if show == Selectors.names {
                            ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                                RecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: srecipe))
                            }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                        }
                        if show == Selectors.random {
                            ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                                RecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: srecipe))
                            }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                        }
                    }
                }
                
            })
            .padding()
        }
    }
}

#if DEBUG
struct FindRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        FindRecipeView()
            .previewDevice("iPhone Xr")
    }
}
#endif
