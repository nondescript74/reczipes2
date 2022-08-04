//
//  AddRecipeView5.swift
//  AddRecipeView5
//
//  Created by Zahirudeen Premji on 8/11/21.
//

import SwiftUI

struct AddRecipeView5: View {
    
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
//        case notificationsOk = "All Set"
//        case urlNotOk = "Need a Valid URL"
//        case urlOk = "Valid Url"
//        case addedRecipe = "Added Recipe"
//        case invalidUrl = "Invalid URl"
//        case enterValidUrl = "Enter valid Recipe URL"
//        case gotIt = "Got It!"
//        case available = " Available"
//        case json = "json"
//        case z = "Z"
//        case imageInfo = "_imageinfo"
//        case creating = "Creating"
//        case notComplete = "Not Complete"
//        case constructedRestrict = "constructed restrictions"
//        case pickSection = "Pick a Recipe Section"
//        case pickbook = "Pick a Recipe Book"
//        case sectionz = "Sections"
        case books = "Recipe Books"
//        case selected = "Selected"
//        case ok = "OK"
//        case notYet = "Not yet"
//        case obtaining = " Being obtained"
//        case saving = "Saving Recipe"
//        case saved = "Saved Recipe"
//        case plussign = "✚"
        case find = "?"
        case random = "🤷🏽‍♂️"
        //case makeFindSelection = "Enter text, click ? or click 🤷🏽‍♂️"
        
    }
    // MARK: - State
    @State private var hasRecipeBook: Bool = false
    @State private var restrictions: String = ""
    @State private var urlString: String = ""
    @State private var xection: Int = 0
    @State private var bookselected: Int = 0
//    @State private var recipeSaved: Bool = false
    @State private var recipeRequested: Bool = false
    @State fileprivate var searchTerm: String = ""
    @State var show: Selectors = .notyet
    // MARK: - Properties
    enum Selectors {
        case notyet
        case names
        case random
        case search
    }
    // MARK: - Methods
//    func verifyUrl(urlString: String?) -> Bool {
//        guard let urlString = urlString,
//              let url = URL(string: urlString) else {
//            return false
//        }
//        extractedSRecipe.findExtracted(urlString: urlString)
//        recipeRequested = true
//        return UIApplication.shared.canOpenURL(url)
//    }
    
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
        sRecipeGroup.findByRandom(searchString: searchTerm, numberSent: numberNeeded)
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
                        SearchBar(text: $searchTerm)
                        Button(action: getSRecipeGroup) {
                            Text(msgs.find.rawValue).fontWeight(.bold)
                        }
                        Button(action: findRandom) {
                            Text(msgs.random.rawValue).fontWeight(.bold)
                        }
                    }
                    
                    Picker(msgs.books.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getBookSectionNames()[index])")
                        }
                    }
                    
                    
                    List   {
                        if show == Selectors.names {
                            ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                                PlusSignAndRecipeRowView(srecipe: srecipe, sectionName: getBookSectionNames()[xection], urlstring: urlString)
                            }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                        }
                        if show == Selectors.random {
                            ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                                PlusSignAndRecipeRowView(srecipe: srecipe, sectionName: getBookSectionNames()[xection], urlstring: urlString)
                            }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                        }
                    }
                }
//                .alert(isPresented: $recipeRequested)   {
//                    if extractedSRecipe.extractedSRecipe?.title != nil {
//                        let item = createRecipeInRecipeBook2()
//                        return Alert(title: Text( item.name + msgs.available.rawValue), message: Text(item.name + msgs.creating.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
//                    } else {
//                        return Alert(title: Text(msgs.notYet.rawValue), message: Text(msgs.obtaining.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
//                    }
//                }
//                .alert(isPresented: $recipeSaved)   {
//                    return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.saved.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
//                }
                
            })
            .padding()
            //.navigationBarTitle(msgs.findRecipe.rawValue)
        }
    }
}

#if DEBUG
struct AddRecipeView5_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView5(show: .notyet)
            .previewDevice("iPhone Xr")
    }
}
#endif




