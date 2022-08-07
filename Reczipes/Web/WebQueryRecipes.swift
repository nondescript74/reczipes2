//
//  WebQueryRecipes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation
import SwiftUI

public class WebQueryRecipes: ObservableObject {
    // MARK: - Environment Variables
    // MARK: - Published
    @Published var anImage: Image?
    @Published var recipeInfo: SRecipe?
    @Published var sRecipeGroup = [SRecipe]()
    @Published var extractedSRecipe: SRecipe?
    @Published var aTrivia: Trivia?
    @Published var joke: Joke?
    // MARK: - State
    // MARK: - Properties
    private enum myQuery: String {
        case query = "query="
        case numberDesired = "&number="
        case ingredients = "ingredients="
        case nutritionFalse = "?includeNutrition=false"
        case nutritionTrue = "?includeNutrition=true"
        case recipeInfo = "&addRecipeInformation=true"
        case extract = "url="
        case trivia, joke = ""
        case cuisine = "&cuisine="
        case tags = "&tags="
    }
    
    enum callerId: String {
        case fullurlbeingsupplied = "Full Url supplied"
        case srecipes = "srecipes"
        case webimage = "fullUrl"
    }
    
    fileprivate enum urlThings: String {
        case recipes = "https://api.spoonacular.com/recipes/search"
        case recipesComplex = "https://api.spoonacular.com/recipes/complexSearch"
        case imageWeb = "https://spoonacular.com/cdn/ingredients_" //  
        case images = "https://spoonacular.com/recipeImages/"
        case ingredients = "https://api.spoonacular.com/recipes/findByIngredients"
        case similar, information = "https://api.spoonacular.com/recipes/"
        case similarPartDeux = "/similar"
        case informationPartDeux = "/information"
        case randomrecipes = "https://api.spoonacular.com/recipes/random"
        case extractedrecipe = "https://api.spoonacular.com/recipes/extract"
        case trivia = "https://api.spoonacular.com/food/trivia/random"
        case joke = "https://api.spoonacular.com/food/jokes/random"
        case defaultURLString = "https://api.spoonacular.com/recipes/196740/information?includeNutrition=false"
    }
    
    enum imageTypes: String {
        case jpg = ".jpg"
        case png = ".png"
        case jpeg = ".jpeg"
    }
    
    enum imageSizes: String {
        case hundredx100 = "100x100"
        case two50x250 = "250x250"
        case five100x500 = "500x500"
    }
    
    enum myGets: String {
        case FindRecipes = "Find Recipes"
        case FindSRecipeGroup = "Find SRecipes"
        case FindImage = "Find Image"
        case FindByIngredients  = "Find By Ingredients"
        case FindByNutrition  = "Find By Nutrition"
        case FindByComplexity  = "Find By Complexity"
        case FindRandom  = "Find Random"
        case FindSimilar = "Find Similar"
        case FindInformation = "My Information"
        case FindSRecipe = "Find SRecipe"
        case FindExtracted = "Extract SRecipe"
        case GetTrivia = "Get Random Trivia"
        case GetJoke = "Get Random Joke"
    }
    
    fileprivate enum messagesDebug: String {
        case foundimage = "Find Image found an Image"
        case foundrandom = "Found Random Recipes"
        case foundrecipeinfo = "Find Information found an SRecipe"
        case foundsrecipe = "Found an SRecipe"
        case foundextractedrecipe = "Extracted an SRecipe"
        case foundsrecipegroup = "Found SRecipeGroup"
        case getTrivia = "Found trivia"
        case getJoke = "Found joke"
        case noTitle = "No title"
        case noTrivia = "No Trivia Found"
        case noJoke = "Found No Joke"
        case unknownImageType = "Unknown image type"
        case unknownCallerID = "Unknown CallerID"
    }
    
    fileprivate var defaultRequiredCount:Int = 0
    
    
    var urlComponents:URLComponents = URLComponents(string: "")!
    var urlComponentsRecipeImages:URLComponents = URLComponents(string: "")!
    
    // MARK: - Methods
    func getMySRecipe(url: URL) {
        urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        myTask(aswitch: myGets.FindSRecipe.rawValue)
    }
    
    func getSearched(searchString: String, numberSent: Int, cuisine: String) {
        if searchString == "" {
            return
        }
        var mySearchTerms = parseSearchString(searchstring: searchString)
        mySearchTerms += " "
        mySearchTerms += cuisine
        urlComponents = URLComponents(string: urlThings.recipesComplex.rawValue)!
        urlComponents.query = myQuery.query.rawValue +  mySearchTerms + myQuery.numberDesired.rawValue + numberSent.description + myQuery.recipeInfo.rawValue + Profile.apiKeyE.z.rawValue
        myTask(aswitch: myGets.FindSRecipeGroup.rawValue)
    }
    
    fileprivate func parseSearchString(searchstring: String) -> String {
        var myReturingString:String = ""
        myReturingString = searchstring.replacingOccurrences(of: ",", with: "+")
        return myReturingString
    }
    
    func getImageFromUrl(urlString: String, type: callerId) {
        urlComponentsRecipeImages = URLComponents(string: parseMyImageUrl(imageName: urlString, type: type.rawValue))!
        myImageTask(aswitch: myGets.FindImage.rawValue)
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
        urlComponents.query = myQuery.numberDesired.rawValue + numberSent.description + myQuery.recipeInfo.rawValue + myQuery.tags.rawValue + tags.lowercased() + Profile.apiKeyE.z.rawValue
        myTask(aswitch: myGets.FindRandom.rawValue)
    }
    
    func findExtracted(urlString: String) {
        // https://api.spoonacular.com/recipes/extract?url=https://foodista.com/recipe/ZHK4KPB6/chocolate-crinkle-cookies&apiKey=apiKey
        if !urlString.isValidURL {
            return
        }
        urlComponents = URLComponents(string: urlThings.extractedrecipe.rawValue)!
        urlComponents.query = myQuery.extract.rawValue + urlString + Profile.apiKeyE.z.rawValue
        myTask(aswitch: myGets.FindExtracted.rawValue)
    }
    
    func getTrivia() {
        urlComponents = URLComponents(string: urlThings.trivia.rawValue)!
        urlComponents.query =  Profile.apiKeyE.z.rawValue
        myTask(aswitch: myGets.GetTrivia.rawValue)
    }
    
    func getJoke() {
        urlComponents = URLComponents(string: urlThings.joke.rawValue)!
        urlComponents.query =  Profile.apiKeyE.z.rawValue
        myTask(aswitch: myGets.GetJoke.rawValue)
    }
    
    private func myImageTask(aswitch: String) {
        guard let url = urlComponentsRecipeImages.url else {
            return
        }
        
        #if DEBUG
        print(url.absoluteString)
        #endif
        
        switch aswitch {
        case myGets.FindImage.rawValue:
            _ = ImageProvider(imageUrl: url) { myImage in
                if myImage != nil {
                    DispatchQueue.main.async {
                        self.anImage = myImage
                        
                        #if DEBUG
                        print(messagesDebug.foundimage.rawValue)
                        #endif
                    }
                }
            }
            
        default:
            fatalError("unrecognized switch")
        }
    }
    
    private func myTask(aswitch: String) {
        guard let url = urlComponents.url else {
            return
        }
        
        #if DEBUG
        print(url.absoluteString)
        #endif
        
        switch aswitch {
        
        case myGets.FindSRecipe.rawValue:
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
                        print(messagesDebug.foundsrecipegroup.rawValue, srecipes?.count ?? self.defaultRequiredCount)
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
                        print(messagesDebug.foundrandom.rawValue, srecipes?.count ?? self.defaultRequiredCount)
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
