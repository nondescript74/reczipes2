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
    // MARK: - Debug local
    private var zBug: Bool = false
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    // MARK: - Published
    @Published var anImage: Image?
    @Published var recipeInfo: SRecipe?
    @Published var sRecipeGroup = [SRecipe]()
    @Published var cRecipeGroup = [CRecipe]()
    @Published var extractedSRecipe: SRecipe?
    @Published var aTrivia: Trivia?
    @Published var joke: Joke?
    @Published var analyzedInstructions: AnalyzedInstructions?
    // MARK: - State
    // MARK: - Properties
    private enum myQuery: String {
        case query = "query="
        case numberDesired = "&number="
        case ingredients = "includeIngredients="
        case nutritionFalse = "includeNutrition=false"
//        case nutritionTrue = "includeNutrition=true"
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
        case similar, information, analyzedInstructions = "https://api.spoonacular.com/recipes/"
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
        case GetAnalyzInstr = "Get Analyzed Instructions"
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
        case fcrgroup = "Found CRecipeGroup"
        case getTrivia = "Found trivia"
        case getJoke = "Found joke"
        case getAnInstr = "Found analyzed instructions"
        case noTitle = "No title"
        case noTrivia = "No Trivia Found"
        case noJoke = "Found No Joke"
        case noAnInstr = "No analyzed instructions found"
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
    
//    func getMySRecipeInfo(id: Int) {
//        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
//        urlComponents = URLComponents(string: urlThings.information.rawValue)!
//        urlComponents.path.append("\(id)")
//        urlComponents.path.append(urlThings.informationPartDeux.rawValue)
//        urlComponents.query = myQuery.nutritionFalse.rawValue + key
//        myTask(aswitch: myGets.FindInformation.rawValue)
//        // https://api.spoonacular.com/recipes/488633/information?includeNutrition=false&apiKey=
//    }
    
    func getSearched(searchString: String, numberSent: Int, cuisine: String) {
        if searchString == "" {
            return
        }
        var mySearchTerms = parseSearchString(searchstring: searchString)
        mySearchTerms += " "
        mySearchTerms += cuisine
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        urlComponents = URLComponents(string: urlThings.recipesComplex.rawValue)!
        urlComponents.query =
        myQuery.query.rawValue + mySearchTerms +
        myQuery.numberDesired.rawValue +
        numberSent.description +
        myQuery.recipeInfo.rawValue + key
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
        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
        urlComponents.query = myQuery.numberDesired.rawValue + numberSent.description + myQuery.recipeInfo.rawValue + myQuery.tags.rawValue + tags.lowercased() + key
        myTask(aswitch: myGets.FindRandom.rawValue)
    }
    
    func findExtracted(urlString: String) {
        // https://api.spoonacular.com/recipes/extract?url=https://foodista.com/recipe/ZHK4KPB6/chocolate-crinkle-cookies&apiKey=
        if !urlString.isValidURL {
            return
        }
        urlComponents = URLComponents(string: urlThings.extractedrecipe.rawValue)!
        urlComponents.query = myQuery.extract.rawValue + urlString + (UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey")
        myTask(aswitch: myGets.FindExtracted.rawValue)
    }
    
//    func findByIngredientsAndCusine(searchString: String, numberSent: Int, cuisine: String) {
//        // https://api.spoonacular.com/recipes/complexSearch?&includeIngredients=chicken,&number=2&cuisine=indian&instructionsRequired=true&apiKey=ccc
//        // findByIngredients(searchString: searchTerm, numberSent: numberNeeded, tags: cuisine)
//        // for example, what's in my fridge
//        // or getting a recipe equivalent to one you have written down
//
//        let key = UserDefaults.standard.string(forKey: "SpoonacularKey") ?? "NoKey"
//        urlComponents = URLComponents(string: urlThings.recipesComplex.rawValue)!
//        urlComponents.query = myQuery.ingredients.rawValue + searchString + myQuery.numberDesired.rawValue + numberSent.description + myQuery.cuisine.rawValue + cuisine.lowercased() + key
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
    
    func getAnalyzedInstructions(recipeID: Int)  {
        urlComponents = URLComponents(string: urlThings.analyzedInstructions.rawValue)!
        urlComponents.path.append("\(recipeID)")
        urlComponents.path.append("analyzedInstructions?")
    }
    
    private func myImageTask(aswitch: String) {
        guard let url = urlComponentsRecipeImages.url else {
            return
        }
        

        if zBug {print(url.absoluteString)}

        
        switch aswitch {
        case myGets.FindImage.rawValue:
            _ = ImageProvider(imageUrl: url) { myImage in
                if myImage != nil {
                    DispatchQueue.main.async {
                        self.anImage = myImage
                        if self.zBug { print(messagesDebug.foundimage.rawValue)}
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
        
        if url.absoluteString.contains("NoKey") {
            return
        }

        if zBug {print(url.absoluteString)}

        switch aswitch {
    
        case myGets.FindSRecipe.rawValue, myGets.FindInformation.rawValue:
            _ = SRecipeProvider(recipesUrl: url) { recipeinfo  in
                if self.recipeInfo != nil {
                    DispatchQueue.main.async { [self] in
                        self.recipeInfo = recipeinfo!
                        if zBug {print(messagesDebug.foundsrecipe.rawValue)}
                    }
                }
            }
            
        case myGets.FindSRecipeGroup.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async { [self] in
                        self.sRecipeGroup = srecipes!
                        if self.zBug {print(messagesDebug.foundsrecipegroup.rawValue, srecipes?.count ?? self.defaultRequiredCount)}
                    }
                }
            }
            
        case myGets.FindRandom.rawValue:
            _ = SRecipeGroupProvider(recipesUrl: url) { srecipes in
                if srecipes != nil {
                    DispatchQueue.main.async {
                        self.sRecipeGroup = srecipes!
                        if self.zBug {print(messagesDebug.foundrandom.rawValue, srecipes?.count ?? self.defaultRequiredCount)}
                    }
                }
            }
            
        case myGets.FindExtracted.rawValue:
            _ = SRecipeProvider(recipesUrl: url) { srecipe in
                if srecipe != nil {
                    DispatchQueue.main.async {
                        self.extractedSRecipe = srecipe!
                        if self.zBug {print(messagesDebug.foundextractedrecipe.rawValue, srecipe?.title ?? messagesDebug.noTitle.rawValue)}
                    }
                }
            }
            
//        case myGets.FindByIngredients.rawValue:
//            _ = CRecipeGroupProvider(recipesUrl: url) { crecipes in
//                if crecipes != nil {
//                    DispatchQueue.main.async {
//                        self.cRecipeGroup = crecipes!
//                        if self.zBug {print(messagesDebug.fcrgroup.rawValue, crecipes?.count ?? "?????")}
//                    }
//                }
//            }
            
        case myGets.GetTrivia.rawValue:
            _ = TriviaProvider(triviaUrl: url) { trivia in
                if trivia != nil {
                    DispatchQueue.main.async {
                        self.aTrivia = trivia!
                        if self.zBug {print(messagesDebug.getTrivia.rawValue, trivia?.text ?? messagesDebug.noTrivia.rawValue)}
                    }
                }
            }
            
        case myGets.GetJoke.rawValue:
            _ = JokeProvider(jokeUrl: url) { joke in
                if joke != nil {
                    DispatchQueue.main.async {
                        self.joke = joke!
                        if self.zBug {print(messagesDebug.getJoke.rawValue, joke?.text ?? messagesDebug.noJoke.rawValue)}
                    }
                }
            }
            
        case myGets.GetAnalyzInstr.rawValue:
            _ = AnalyzedInstructionsProvider(analyzedInstructionsUrl: url) { analyzInstr in
                if analyzInstr != nil {
                    DispatchQueue.main.async {
                        self.analyzedInstructions = analyzInstr!
                        if self.zBug {print(messagesDebug.getAnInstr.rawValue, analyzInstr?.steps?.count ?? messagesDebug.noAnInstr.rawValue)}
                    }
                }
            }
            
        default:
            fatalError("unrecognized switch")
        }
    }
}
