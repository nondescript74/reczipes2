//
//  WebQueryRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation
import SwiftUI
import Combine
import OSLog

@Observable public class WebQueryRecipes {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "WebQueryRecipes")
    let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "No Key"
    var urlComponents = URLComponents()
    
    enum messagesDebug: String {
        case foundimage = "WQR: Find Image found an Image"
        case foundrandom = "WQR: Found Random Recipes"
        case foundrecipeinfo = "WQR: Find Information found an SRecipe"
        case foundsrecipe = "WQR: Found an SRecipe"
        case foundextractedrecipe = "WQR: Extracted an SRecipe"
        case fsrgroup = "WQR: Found SRecipeGroup"
        case fcrgroup = "WQR: Found CRecipeGroup"
        case getTrivia = "WQR: Found trivia"
        case getJoke = "WQR: Found joke"
        case getAnInstr = "WQR: Found analyzed instructions"
        case noTitle = "WQR: No title"
        case noTrivia = "WQR: No Trivia Found"
        case noJoke = "WQR: Found No Joke"
        case noAnInstr = "WQR: No analyzed instructions found"
        case unknownImageType = "WQR: Unknown image type"
        case unknownCallerID = "WQR: Unknown CallerID"
    }
    
    /*
     var urlComponents = URLComponents()
     urlComponents.scheme = "https"
     urlComponents.host = "api.spoonacular.com"
     urlComponents.path = "/recipes/complexSearch"
     
     var queryItems: [URLQueryItem] = []
     queryItems.append(URLQueryItem(name: "query", value: searchString))
     queryItems.append(URLQueryItem(name: "number", value: number.description))
     queryItems.append(URLQueryItem(name: "cuisine", value: cuisine))
     queryItems.append(URLQueryItem(name: "addRecipeInformation", value: showInfo ? "true" : "false"))
     urlComponents.queryItems = queryItems
     urlComponents.query! += "\(key)"
     guard let url = urlComponents.url else {
         logger.log( "could not create url , cannot fetch data")
         return
     }
     */

    // MARK: - Published
    var recipeInfo: SRecipe?
    var sRecipeGroup = [SRecipe]()
    var extractedSRecipe: SRecipe?
    var aTrivia: Trivia?
    var joke: Joke?
    
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
        if !urlString.isValidURL {
            logger.error("urlString supplied is not a valid URL: \(urlString)")
            return
        }
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/extract"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "url", value: urlString))
        queryItems.append(URLQueryItem(name: "analyze", value: "true"))
        queryItems.append(URLQueryItem(name: "forceExtraction", value: "true"))
        urlComponents.queryItems = queryItems
        urlComponents.query! += "\(key)"
        guard urlComponents.url != nil else {
            logger.log( "could not create url , cannot fetch data")
            return
        }
        logger.info("URL for extraction via urlcomponents is \(self.urlComponents.debugDescription)")
        myTask(aswitch: myGets.FindExtracted.rawValue)
        logger.info("Extracting recipe from URL")
    }
    
//    func findByIngredientsAndCusine(searchString: String, numberSent: Int, cuisine: String) {
//        // https://api.spoonacular.com/recipes/complexSearch?&includeIngredients=chicken,&number=2&cuisine=indian&instructionsRequired=true&apiKey=ccc
//        // https://api.spoonacular.com/recipes/findByIngredients?ingredients=apples,+flour,+sugar&number=2
//        // findByIngredients(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
//        // for example, what's in my fridge
//        // or getting a recipe equivalent to one you have written down
//        
//        if searchString.isEmpty {
//            return
//        }
//        
//        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
//        urlComponents = URLComponents(string: urlThings.recipesComplex.rawValue)!
//        urlComponents.query = myQuery.ingredients.rawValue + searchString + myQuery.cuisine.rawValue + cuisine + myQuery.numberDesired.rawValue + numberSent.description + key
//        myTask(aswitch: myGets.FindByIngredients.rawValue)
//    }
    
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
            logger.error("Cannot create URL from urlComponents")
            return
        }
        
        if url.absoluteString.contains("No Key") {
            logger.error("No Key in UserDefaults")
            return
        }
        logger.info("Getting from \(url.absoluteString)")
        switch aswitch {
        case myGets.FindSRecipe.rawValue, myGets.FindInformation.rawValue:
            _ = SRecipeProvider(recipesUrl: url) { recipeinfo  in
                if self.recipeInfo != nil {
                    DispatchQueue.main.async { [self] in
                        self.recipeInfo = recipeinfo!
                        self.logger.info("\(messagesDebug.foundsrecipe.rawValue)")
                    }
                }
            }
        case myGets.FindSRecipeGroup.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async { [self] in
                        self.sRecipeGroup = srecipes!
                        self.logger.info("\(messagesDebug.fsrgroup.rawValue)")
                    }
                }
            }
        case myGets.FindRandom.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async {
                        self.sRecipeGroup = srecipes!
                        self.logger.info("\(messagesDebug.foundrandom.rawValue)")
                    }
                }
            }
        case myGets.FindExtracted.rawValue:
            _ = SRecipeProvider(recipesUrl: url) { srecipe in
                if srecipe != nil {
                    DispatchQueue.main.async {
                        self.extractedSRecipe = srecipe!
                        self.logger.info("\(messagesDebug.foundextractedrecipe.rawValue)")
                    }
                }
            }
        case myGets.FindByIngredients.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async {
                        self.sRecipeGroup = srecipes!
                        self.logger.info("\(messagesDebug.fsrgroup.rawValue)")
                    }
                }
            }
        case myGets.GetTrivia.rawValue:
            _ = TriviaProvider(triviaUrl: url) { trivia in
                if trivia != nil {
                    DispatchQueue.main.async {
                        self.aTrivia = trivia!
                        self.logger.info("\(messagesDebug.getTrivia.rawValue)")
                    }
                }
            }
        case myGets.GetJoke.rawValue:
            _ = JokeProvider(jokeUrl: url) { joke in
                if joke != nil {
                    DispatchQueue.main.async {
                        self.joke = joke!
                        self.logger.info("\(messagesDebug.getJoke.rawValue)")
                    }
                }
            }

        default:
            self.logger.error("\(messagesDebug.unknownCallerID.rawValue)")
            fatalError("unrecognized switch")
        }
    }
}
