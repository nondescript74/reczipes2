//
//  MultiView.swift
//  CRecipes
//
//  Created by Zahirudeen Premji on 12/9/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct MultiView: View {// MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var addedRecipes: AddedRecipes
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // MARK: - ObservedObject
    @ObservedObject var sRecipeGroup = WebQueryRecipes()  // an array of srecipes
    @ObservedObject var trivia = WebQueryRecipes()
    @ObservedObject var joke = WebQueryRecipes()
    
    // MARK: - State
    @State fileprivate var searchTerm : String = ""
    @State var show: Selectors
    @State fileprivate var showingProfile: Bool = false
    
    // MARK: - Properties
    enum Selectors {
        case notyet
        case names
        case random
        case trivia
        case joke
        case chat
    }
    
    fileprivate enum msgs: String {
        case findrecipes = "Find Recipes"
        case readFilesInASDsuccess = "Success"
        case userProfile = "User Profile"
        case makeSelection = "Enter text, click Find. Or Search/Random/Joke/Trivia"
        case noTitle = "No Recipe Title"
        case noJoke = "No Joke?"
        case noTrivia = "No Trivia?"
    }
    
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(uiImage: UIImage(named: "zhome")!.scaledDown(into: CGSize(width: 40, height: 40), centered: true))
                .imageScale(.large)
                .accessibility(label: Text(msgs.userProfile.rawValue))
                .padding()
        }
    }
    
    // MARK:- Methods
    func getTrivia() {
        show = Selectors.trivia
        trivia.getTrivia()
    }
    
    func getJoke() {
        show = Selectors.joke
        joke.getJoke()
    }
    
    func getSRecipeGroup() {
        show = Selectors.names
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        sRecipeGroup.getSearched(searchString: searchTerm, numberSent: numberNeeded)
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
    
    func convertSRecipeToSectionItem(srecipe: SRecipe) -> SectionItem {
        let returningSecItem = SectionItem(id: UUID(),
                                           name: srecipe.title ?? SectionItem.example.name,
                                           url: srecipe.sourceUrl ?? SectionItem.example.url,
                                           imageUrl: srecipe.image,
                                           photocredit: srecipe.creditsText ?? SectionItem.example.photocredit,
                                           restrictions: constructRestrictions(srecipe: srecipe))
        return returningSecItem
    }
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    SearchBar(text: $searchTerm)
                    Text(msgs.makeSelection.rawValue)
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        Button(action: {self.getSRecipeGroup()}) {
                            RoundedButtonView(someText: "Find", someImage: Image("Find Recipes-thumb"))
                        }.disabled(searchTerm == "")
                        .padding()
                        Button(action: {self.findRandom()}) {
                            RoundedButtonView(someText: "Random", someImage: Image("Random Recipes-thumb"))
                        }.padding()
                        Button(action: {self.getTrivia()}) {
                            RoundedButtonView(someText: "Trivia", someImage: Image("Trivia-thumb"))
                        }.padding()
                        Button(action: {self.getJoke()}) {
                            RoundedButtonView(someText: "Joke", someImage: Image("Joke-thumb"))
                        }.padding()
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
                        if show == Selectors.trivia {
                            Text(trivia.aTrivia?.text ?? msgs.noTrivia.rawValue)
                                .lineLimit(20)
                        }
                        if show == Selectors.joke {
                            Text(joke.joke?.text ?? msgs.noJoke.rawValue)
                                .lineLimit(20)
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        
    }
}

#if DEBUG
struct MultiView_Previews: PreviewProvider {
    static var previews: some View {
        MultiView(show: .notyet)
            .previewDevice("iPhone Xr")
    }
}
#endif
