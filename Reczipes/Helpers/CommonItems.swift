//
//  CommonItems.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/13/21.
//

import UIKit
import SwiftUI
import Foundation
import Combine


public var colorFontLists:Color = Color.init("ED7D3A")
public var iPhoneXrPreviewDevice:PreviewDevice = "iPhone Xr"
public var iPadAir2PreviewDevice:PreviewDevice = "iPad Air 2"
public let spoonacular:String = "Spoonacular"
public let recipesName = "Reczipes"
public let recipeNotesFolderName = "RecipeNotes"
public let recipeImagesFolderName = "RecipeImages"
public let json = ".json"
public let colorA:Color = Color.init("A4B8C4")
public let colorB:Color = Color.init("6E8387")

let suitImage =  UIImage(systemName: "suit.heart")!
let checkmarkImage = UIImage(systemName: "checkmark.seal")!
let lassoImage = UIImage(systemName: "lasso")!
let wandNStarsImage = UIImage(systemName: "wand.and.stars")!
let rectandtextmagglass = UIImage(systemName: "rectangle.and.text.magnifyingglass")
let docandtextmagglass = UIImage(systemName: "doc.text.magnifyingglass")
let crosscirclefill = UIImage(systemName: "cross.circle.fill")
let tortoise = UIImage(systemName: "tortoise")
let hare = UIImage(systemName: "hare")
let imageSquarePencil = UIImage(systemName: "square.and.pencil")
let imageSuitSpadeEmpty = UIImage(systemName: "suite.spade")
let imageDocDocEmpty = UIImage(systemName: "doc.on.doc")
let imageDocDocFill = UIImage(systemName: "doc.on.doc.fill")
let scribblevariable = UIImage(systemName: "scribble.variable")
let rectstackbadgepersoncrop = UIImage(systemName: "rectangle.stack.badge.person.crop")
let questionmarkcircle = UIImage(systemName: "questionmark.circle")
let folderfillbadgeplus = UIImage(systemName: "folder.fill.badge.plus")
let magnifyingglass = UIImage(systemName: "magnifyingglass")
let lassosparkles = UIImage(systemName: "lasso.sparkles")
let squareandarrowdown = UIImage(systemName:"square.and.arrow.down")
let videobadgeplus = UIImage(systemName:"video.badge.plus")
let delimiterFileNames = "_Z_"
let delimiterDirs = "/"
let delimiterFiletype = "."
let defaultRecipeUrlString = "https://www.seriouseats.com/recipes/2014/04/easy-stir-fried-beef-with-mushrooms-and-butter.html"

let defaultImageUrl = "https://imagesvc.meredithcorp.io/v3/mm/image?q=85&c=sc&poi=face&w=2048&h=1072&url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F609167.jpg"
let defaultImageUr2 = "https://i1.wp.com/www.givemesomespice.com/wp-content/uploads/2011/07/IMG_0868.jpg?ssl=1"
let defaultUUID = "F4DA7B28-D403-4313-8AFF-E9645587C99E"

let myMeasure: Measure = Bundle.main.decode(Measure.self, from: "Measure.json")
let myMeasures: Measures = Bundle.main.decode(Measures.self, from: "Measures.json")
let myExtendedIngredient: ExtendedIngredient = Bundle.main.decode(ExtendedIngredient.self, from: "ExtendedIngredient.json")
let myExtendedIngredients: [ExtendedIngredient] = Bundle.main.decode([ExtendedIngredient].self, from: "ExtendedIngredients.json")


var colorBackgroundButton: Color = Color.init("ED7D3A")
var colorForegroundButton: Color = Color.init("A4B8C4")
let colors: [String: Color] = ["D": .purple, "G": .pink, "N": .red, "S": .blue, "V": .green, "VX": .green, "L": .gray, "H": .orange, "P": .yellow]
let myMax: Int = Int.max
let myMaxInt64: Int64 = Int64.max

fileprivate enum msgs: String {
    
    case returningpresetrecipes = "Returning Preset Recipes "
    case returningbooksectionssf = "Returning BookSections in single file"
    case rshipd = "recipesShipped"
    case rnotes = "RecipeNotes"
    case rimages = "RecipeImages"
    case fuar = "Found user added recipe"
    case combined = "Combined booksections into one booksection"
    case ci = "CommonItems: "
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
    return myList.first ?? Ingredient(name: name, id: Int64.random(in: 1..<myMaxInt64-1))
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

func convertSRecipeToSectionItem(srecipe: SRecipe) -> SectionItem {
    let item = SectionItem(id: UUID(),
                           name: srecipe.title ?? SectionItem.example.name,
                           url: srecipe.sourceUrl ?? SectionItem.example.url,
                           imageUrl: srecipe.image,
                           photocredit: srecipe.creditsText ?? SectionItem.example.photocredit,
                           restrictions: srecipe.diets ?? [])
//                           restrictions: constructRestrictions(srecipe: srecipe))
    
#if DEBUG
    print(msgs.ci.rawValue + "Converted SRecipe to SectionItem " + item.name)
#endif
    
    return item
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
