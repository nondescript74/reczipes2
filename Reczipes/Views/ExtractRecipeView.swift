//
//  ExtractRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/16/22.
//

import SwiftUI

struct ExtractRecipeView: View {
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    // MARK: - State
    @State private var urlString: String = ""
    @State private var recipeRequested: Bool = false
    @State private var show: Selectors = .notyet
    @State private var xection: Int = 0
    // MARK: - Properties
    fileprivate var cuisine = ""
    enum Selectors {
        case notyet
        case extract
    }
    fileprivate enum msgs: String {
        case er = "Extract Recipe"
        case entertext = "Enter Recipe URL"
        case extract = "✂️"
        case books = "Recipe Books"

    }
    // MARK: - Methods
    func extractRecipe() {
        show = Selectors.extract
        extractedSRecipe.findExtracted(urlString: urlString)
        urlString = ""
        endEditing()
    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        NavigationView {
//            GeometryReader(content: { geometry in
                VStack {
                    Text(msgs.er.rawValue).font(.largeTitle).bold()
                    Picker(msgs.books.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getBookSectionNames()[index])")
                        }
                    }
                    
                    HStack(alignment: .center) {
                        TextField(msgs.entertext.rawValue, text: $urlString)
                        Button(action: extractRecipe) {
                            Text(msgs.extract.rawValue).font(.largeTitle).bold()
                        }.padding(.trailing, 20)

                    }
                    
                    List   {
                        if show == Selectors.extract {
                            RecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: extractedSRecipe.extractedSRecipe ?? SRecipe.example), cuisine: getBookSectionNames()[xection])
                        }
                    }
                }.padding()
//            })
//            .padding()
        }
    }
}

struct ExtractRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        ExtractRecipeView()
    }
}
