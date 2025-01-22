//
//  WebQueryRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation
import SwiftUI
import Combine

public class WebQueryRecipes: ObservableObject {

    // MARK: - Published
    @Published var recipeInfo: SRecipe?
    @Published var sRecipeGroup = [SRecipe]()
    @Published var extractedSRecipe: SRecipe?
    @Published var aTrivia: Trivia?
    @Published var joke: Joke?
    
    // MARK: - Methods
    func getMySRecipe(url: URL) {
        urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        myTask(aswitch: myGets.FindSRecipe.rawValue)
    }
    
    func complexSearch(searchString: String, numberSent: Int, cuisine: String) {
        if searchString == "" {
            return
        }
        var mySearchTerms = searchString
        mySearchTerms += "&cuisine="
        mySearchTerms += cuisine
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        urlComponents = URLComponents(string: urlThings.recipesComplex.rawValue)!
        urlComponents.query = myQuery.query.rawValue +  mySearchTerms +
        myQuery.numberDesired.rawValue +
        numberSent.description +
        myQuery.recipeInfo.rawValue + key
        myTask(aswitch: myGets.FindByIngredients.rawValue)
    }
    
    private func parseMyImageUrl(imageName: String, type: callerId.RawValue) -> String {
        var myRetStr = ""
        switch type {
        case callerId.fullurlbeingsupplied.rawValue:
            myRetStr = imageName
        case callerId.srecipes.rawValue, callerId.webimage.rawValue:
            myRetStr =  urlThings.imageWeb.rawValue + imageSizes.hundredx100.rawValue + delimiterDirs + imageName
        default:
            fatalError(messagesDebug.unknownCallerID.rawValue)
        }
        return myRetStr
    }
    
    func findByRandom(searchString: String, numberSent: Int, tags: String) {
        urlComponents = URLComponents(string: urlThings.randomrecipes.rawValue)!
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        urlComponents.query = myQuery.numberDesired.rawValue + numberSent.description + myQuery.recipeInfo.rawValue + myQuery.tags.rawValue + tags.lowercased() + key
        myTask(aswitch: myGets.FindRandom.rawValue)
    }
    
    func findExtracted(urlString: String) {
        https://api.spoonacular.com/recipes/extract?url=https://www.seriouseats.com/vegan-cashew-milk-braised-green-plantains&analyze=true&forceExtraction=true&analyze=true&apiKey=
        if !urlString.isValidURL {
#if DEBUG
            print("WQR: invalid url supplied")
#endif
            return
        }
        urlComponents = URLComponents(string: urlThings.extractedrecipe.rawValue)!
        urlComponents.query = myQuery.extract.rawValue + urlString + myQuery.anlyztrue.rawValue + myQuery.forceExtracttrue.rawValue + (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")
        myTask(aswitch: myGets.FindExtracted.rawValue)
#if DEBUG
        print("WQR: url generated is: " + urlComponents.debugDescription)
#endif
    }
    
    func findByIngredientsAndCusine(searchString: String, numberSent: Int, cuisine: String) {
        // https://api.spoonacular.com/recipes/complexSearch?&includeIngredients=chicken,&number=2&cuisine=indian&instructionsRequired=true&apiKey=ccc
        // https://api.spoonacular.com/recipes/findByIngredients?ingredients=apples,+flour,+sugar&number=2
        // findByIngredients(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
        // for example, what's in my fridge
        // or getting a recipe equivalent to one you have written down
        
        if searchString.isEmpty {
            return
        }
        
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        urlComponents = URLComponents(string: urlThings.recipesComplex.rawValue)!
        urlComponents.query = myQuery.ingredients.rawValue + searchString + myQuery.cuisine.rawValue + cuisine + myQuery.numberDesired.rawValue + numberSent.description + key
        myTask(aswitch: myGets.FindByIngredients.rawValue)
    }
    
    func getTrivia() {
        urlComponents = URLComponents(string: urlThings.trivia.rawValue)!
        urlComponents.query =  (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")
        myTask(aswitch: myGets.GetTrivia.rawValue)
    }
    
    func getJoke() {
        urlComponents = URLComponents(string: urlThings.joke.rawValue)!
        urlComponents.query =  (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")
        myTask(aswitch: myGets.GetJoke.rawValue)
    }
    
    private func myTask(aswitch: String) {
        guard let url = urlComponents.url else {
            return
        }
        
        if url.absoluteString.contains("NoKey") {
            return
        }
#if DEBUG
        print("WQR: getting from ", url.absoluteString)
#endif

        switch aswitch {
    
        case myGets.FindSRecipe.rawValue, myGets.FindInformation.rawValue:
            _ = SRecipeProvider(recipesUrl: url) { recipeinfo  in
                if self.recipeInfo != nil {
                    DispatchQueue.main.async { [self] in
                        self.recipeInfo = recipeinfo!
#if DEBUG 
                        print(messagesDebug.foundsrecipe.rawValue)
#endif
                    }
                }
            }
            
        case myGets.FindSRecipeGroup.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async { [self] in
                        self.sRecipeGroup = srecipes!
#if DEBUG
                        print(messagesDebug.fsrgroup.rawValue, srecipes?.count ?? defaultRequiredCount)
#endif
                    }
                }
            }
            
        case myGets.FindRandom.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async {
                        self.sRecipeGroup = srecipes!
#if DEBUG
                        print(messagesDebug.foundrandom.rawValue, srecipes?.count ?? defaultRequiredCount)
#endif
                    }
                }
            }
            
        case myGets.FindExtracted.rawValue:
            _ = SRecipeProvider(recipesUrl: url) { srecipe in
                if srecipe != nil {
                    DispatchQueue.main.async {
                        self.extractedSRecipe = srecipe!
#if DEBUG
                        print(messagesDebug.foundextractedrecipe.rawValue, srecipe?.title ?? messagesDebug.noTitle.rawValue)
#endif
                    }
                }
            }
            
        case myGets.FindByIngredients.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async {
                        self.sRecipeGroup = srecipes!
#if DEBUG
                        print(messagesDebug.fsrgroup.rawValue, srecipes?.count ?? "couldn't get count")
#endif
                    }
                }
            }
            
        case myGets.GetTrivia.rawValue:
            _ = TriviaProvider(triviaUrl: url) { trivia in
                if trivia != nil {
                    DispatchQueue.main.async {
                        self.aTrivia = trivia!
#if DEBUG
                        print(messagesDebug.getTrivia.rawValue, trivia?.text ?? messagesDebug.noTrivia.rawValue)
#endif
                    }
                }
            }
            
        case myGets.GetJoke.rawValue:
            _ = JokeProvider(jokeUrl: url) { joke in
                if joke != nil {
                    DispatchQueue.main.async {
                        self.joke = joke!
#if DEBUG
                        print(messagesDebug.getJoke.rawValue, joke?.text ?? messagesDebug.noJoke.rawValue)
#endif
                    }
                }
            }

        default:
            fatalError("unrecognized switch")
        }
    }
}
