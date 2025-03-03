//
//  CommonItems.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/13/21.
//

import SwiftUI
import Foundation
import Combine

public let spoonacular:String = "Spoonacular"
public let recipesName = "Reczipes"
public let recipeNotesFolderName = "RecipeNotes"
public let recipeImagesFolderName = "RecipeImages"
public let json = ".json"

public let colorA:Color = Color.init("A4B8C4")
public let colorB:Color = Color.init("6E8387")
var colorBackgroundButton: Color = Color.black
var colorForegroundButton: Color = Color.blue
public var colorFontLists:Color = Color.init("ED7D3A")

let videobadgeplus = UIImage(systemName:"video.badge.plus")
let delimiterFileNames = "_Z_"
let delimiterDirs = "/"
let delimiterFiletype = "."

let shippedDiets: [Diet] =  Bundle.main.decode([Diet].self, from: "diets.json")

let showShipped: Bool = false

let myMax: Int = Int.max
let myMaxInt64: Int64 = Int64.max
let targetsize = CGSize(width: 90.0, height: 60.0)
let skey = "SpoonacularKey"
let widthImage: CGFloat = 100
let heightImage: CGFloat = 70
let overlayLWidth: CGFloat = 2
let paddingSize: CGFloat = 2
let lineLimit: Int = 3
let imageTargetSize = CGSize(width: 200, height: 200)

let allColors: [Color] = [     .pink,
                               .red,
                               .orange,
                               .yellow,
                               .green,
                               .mint,
                               .teal,
                               .cyan,
                               .blue,
                               .indigo,
                               .purple,
                               .brown,
                               .gray
]

var defaultRequiredCount:Int = 0
var urlComponents:URLComponents = URLComponents(string: "")!
var urlComponentsRecipeImages:URLComponents = URLComponents(string: "")!

enum myQuery: String {
    case query = "query="
    case numberDesired = "&number="
    case ingredients = "ingredients="
    case nutritionFalse = "includeNutrition=false"
    case nutritionTrue = "includeNutrition=true"
    case recipeInfo = "&addRecipeInformation=true"
    case extract = "url="
    case forceExtracttrue = "&forceExtraction=true"
    case trivia, joke = ""
    case cuisine = "&cuisine="
    case tags = "&tags="
    case anlyztrue = "&analyze=true"
}

enum callerId: String {
    case fullurlbeingsupplied = "Full Url supplied"
    case srecipes = "srecipes"
    case webimage = "fullUrl"
}

enum urlThings: String {
    case recipes = "https://api.spoonacular.com/recipes/search"
    case recipesComplex = "https://api.spoonacular.com/recipes/complexSearch"
    case imageWeb = "https://spoonacular.com/cdn/ingredients_" //
    case images = "https://spoonacular.com/recipeImages/"
    case ingredients = "https://api.spoonacular.com/recipes/findByIngredients"  // https://api.spoonacular.com/recipes/findByIngredients
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
    case GetAnalyzInstr = "Get Analyzed Instructions"
    case FindRandom  = "Find Random"
    case FindSimilar = "Find Similar"
    case FindInformation = "My Information"
    case FindSRecipe = "Find SRecipe"
    case FindExtracted = "Extract SRecipe"
    case GetTrivia = "Get Random Trivia"
    case GetJoke = "Get Random Joke"
}

func getBookSectionNames() -> [String] {
    let namesOfCuisines = Bundle.main.decode([Cuisine].self, from: "cuisines.json").sorted(by: {$0.name < $1.name})
    var names: [String] = []
    namesOfCuisines.forEach {names.append($0.name)}
    return names
}

func hasSpecialCharacters(string: String) -> Bool {
    if string.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil {
        return true
    } else {
        return false
    }
}

func getIngredList() -> [Ingredient] {
    let listOfIngredients:[Ingredient] = Bundle.main.decode([Ingredient].self, from: "ingredients_list.json").sorted(by: {$0.id < $1.id})
    return listOfIngredients
}

func getIngredientForName(name: String) -> Ingredient {
    let myList = getIngredList().filter({$0.name == name})
    return myList.first ?? Ingredient(id: Int.random(in: 1..<999999), name: name)
}

func getDocuDirUrl() -> URL {
    var myReturn:URL
    do {
        let myDocuDirUrl = try FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
        myReturn = myDocuDirUrl
    } catch {
        fatalError()
    }
    return myReturn
}

func convertSRecipeToSectionItem3(srecipe: SRecipe) -> SectionItem3 {
    let item = SectionItem3(id: UUID(),
                            recipeId: getSRecipeID(srecipe: srecipe),
                            name: srecipe.title ?? SectionItem3.example.name,
                            url: srecipe.sourceUrl ?? SectionItem3.example.url,
                            imageUrl: srecipe.image,
                            photocredit: srecipe.creditsText ?? SectionItem3.example.photocredit,
                            restrictions: constructRestrictionsWithSRecipe(srecipe: srecipe),
                            summary: srecipe.summary ?? SectionItem3.example.summary)
    return item
}
                            

func getSRecipeID(srecipe: SRecipe) -> Int {
    switch srecipe.id {
    case Int.min ..< 1:
#if DEBUG
        print("CommonItems: srecipe has negative id")
#endif
        return getSRecipeIDUnique()
    default:
        return srecipe.id
    }
}

func getSRecipeIDUnique() -> Int {
    // for now
    return 999999999
}

func constructRestrictionsWithSRecipe(srecipe: SRecipe) -> [String] {
    var myRestrictions: [String] = []

    if srecipe.cheap == true {
        myRestrictions.append("Cheap")
    }
    if srecipe.dairyFree == true {
        myRestrictions.append("Dairy Free")
    }
    if srecipe.glutenFree == true {
        myRestrictions.append("Gluten Free")
    }
    if srecipe.lowFodmap == true {
        myRestrictions.append("LOWFODMAP")
    }
    if srecipe.sustainable == true {
        myRestrictions.append("Sustainable")
    }
    if srecipe.vegan == true {
        myRestrictions.append("Vegan")
    }
    if srecipe.vegetarian == true {
        myRestrictions.append("Vegetarian")
    }
    if srecipe.veryHealthy == true {
        myRestrictions.append("Very Healthy")
    }
    if srecipe.veryPopular == true {
        myRestrictions.append("Very Popular")
    }

#if DEBUG
    print(myRestrictions)
#endif
    return myRestrictions
}


func getUnitsMetric() -> [String] {
    let units = ["ml", "cl", "liters", "grams", "kilograms"]
    return units
}

func getUnitsImperial() -> [String] {
    let units = ["teaspoon", "tablespoon", "cup", "pint", "quart", "gallon"]
    return units
}

func getValues(unit: String) -> [String] {
    var formattedValues: [String] = []
    switch unit {
        
    case "metric":
        let values: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10.0]
        for value in values {
            formattedValues.append(formatDigits(numberToFormat: value))
        }
        return formattedValues
        
    case "imperial":
        let values: [String] = ["1/8", "1/4", "1/2", "3/4", "7/8", "1", "2", "3", "4", "5", "10"]
        return values
    default:
        let values: [String] = ["1/8", "1/4", "1/2", "3/4", "7/8", "1", "2", "3", "4", "5", "10"]
        return values
    }
    
}

func formatDigits(numberToFormat: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumSignificantDigits = 2
    guard let retStr = formatter.string(for: numberToFormat) else { return "No value" }
    return retStr
}

func formatStringDoubleToNumber(stringToFormat: String) -> Double {
    let formatter = NumberFormatter()
    formatter.maximumSignificantDigits = 2
    formatter.numberStyle = .decimal
    let retNum = formatter.number(from: stringToFormat)
    return retNum?.doubleValue ?? 0
}

func dateSuffix() -> String {
    var retStr = Date().timeIntervalSinceReferenceDate.rounded().description
    retStr.removeLast()
    retStr.removeLast()
    return retStr
}
