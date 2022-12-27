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
//public let recipeFolderName = "RecipeFolder"
//public let recipeImagesAndNotesFolderName = "NotesPlusImages"
public let recipesName = "Reczipes"
public let recipeNotesFolderName = "RecipeNotes"
public let recipeImagesFolderName = "RecipeImages"
//public var recipeBooks:[String] = ["CRecipeBook0", "IndianRecipes0", "Added Recipes"]
//public var recipeBooks2:[String] = ["Carol", "Indian", "Added", "Diane", "Z", "Rafiq", "Chinese"]
let myBookSectionsIdNames: [BookSectionIDName] = Bundle.main.decode([BookSectionIDName].self, from: "SectionNames.json")
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

private var decoder: JSONDecoder = JSONDecoder()
private var encoder: JSONEncoder = JSONEncoder()


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

func constructRestrictions(srecipe: SRecipe) -> [String] {
    var myRestrictions:[String] = []
    
    if ((srecipe.sustainable) != nil) && srecipe.sustainable == true {
        myRestrictions.append("SUST")
    }
    if (((srecipe.cheap) != nil)  && (srecipe.cheap) == true) {
        myRestrictions.append("CHEAP")
    }
    if (((srecipe.vegan) != nil)  && (srecipe.vegan) == true) {
        myRestrictions.append("VEGAN")
    }
    if (((srecipe.vegetarian) != nil)  && (srecipe.vegetarian) == true) {
        myRestrictions.append("VEGET")
    }
    if (((srecipe.glutenFree) != nil)  && (srecipe.glutenFree) == true) {
        myRestrictions.append("GlutenF")
    }
    if (((srecipe.dairyFree) != nil)  && (srecipe.dairyFree) == true) {
        myRestrictions.append("DairyF")
    }
    if (((srecipe.veryHealthy) != nil)  && (srecipe.veryHealthy) == true) {
        myRestrictions.append("VeryH")
    }
    if (((srecipe.veryPopular) != nil)  && (srecipe.veryPopular) == true) {
        myRestrictions.append("VeryPop")
    }
    if (((srecipe.lowFodmap) != nil)  && (srecipe.lowFodmap) == true) {
        myRestrictions.append("LowFMp")
    }
    return myRestrictions
}

func convertSRecipeToSectionItem(srecipe: SRecipe) -> SectionItem {
    let item = SectionItem(id: UUID(),
                           name: srecipe.title ?? SectionItem.example.name,
                           url: srecipe.sourceUrl ?? SectionItem.example.url,
                           imageUrl: srecipe.image,
                           photocredit: srecipe.creditsText ?? SectionItem.example.photocredit,
                           restrictions: constructRestrictions(srecipe: srecipe))
    
#if DEBUG
    print(msgs.ci.rawValue + item.name)
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

func getBookSectionsIDNames() -> [BookSectionIDName] {
    let bsin:[BookSectionIDName] = Bundle.main.decode([BookSectionIDName].self, from: "SectionNames.json").sorted(by: {$0.name < $1.name})
    return bsin
}

func getBookSectionNames() -> [String] {
    let bsin = getBookSectionsIDNames()
    var returningNames: [String] = []
    for abs in bsin {
        returningNames.append(abs.name)
    }
    return returningNames
}

//func getBookSectionNames() -> [String] {
//    var cuisines:[Cuisine] = Bundle.main.decode([Cuisine].self, from: "cuisines.json").sorted(by: {$0.name < $1.name})
//    var returningNames: [String] = []
//    for acuisine in cuisines {
//        returningNames.append(acuisine.name)
//    }
//    return returningNames
//}


func dateSuffix() -> String {
    var retStr = Date().timeIntervalSinceReferenceDate.rounded().description
    retStr.removeLast()
    retStr.removeLast()
    return retStr
}

func getBookSectionIDForName(name: String) -> UUID {
    var myReturn:UUID
    // special characters are escaped
    if getBookSectionNames().contains(name) {
        // bs name exists, recipes may not exist in the section
        var sections = FileManager.default.constructAllSections()
        sections = sections.filter({$0.name == name})
        if sections.isEmpty {
            var builtinNames = myBookSectionsIdNames
            builtinNames = builtinNames.filter({$0.name == name})
            if builtinNames.isEmpty {
                fatalError("no uuid available for name")
            }
            myReturn = builtinNames.first!.id
        } else {
            myReturn = sections.first!.id
        }
        
    } else {
        fatalError("no id with name in builtin booksectionnames")
    }
    return myReturn
}

func getBookSectionWithUUID(bookSectionUUID: UUID) -> BookSection? {
    var myReturn:BookSection?
    let bs = FileManager.default.constructAllSections().filter({$0.id == bookSectionUUID})
    myReturn = bs.first
    return myReturn
}


func addRecipeToBookSection(recipe: SectionItem, bookSectionUUID: UUID) -> Bool {
    
    let myDocuDirUrl = getDocuDirUrl()
    let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        
    if (getBookSectionWithUUID(bookSectionUUID: bookSectionUUID) != nil) {
        // exists
        do {
            let abookSection = getBookSectionWithUUID(bookSectionUUID: bookSectionUUID)!
            if abookSection.items.contains(where: {$0.url == recipe.url}) {
                return false  // don't add recipe already in
            }
            do {
                let newBookSection = BookSection(id: abookSection.id, name: abookSection.name, items: [recipe])
                let encodedJSON = try encoder.encode(newBookSection)
                // now write out
                try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(newBookSection.name + "_" + dateSuffix() + json))
                #if DEBUG
                print("Successfully wrote booksection")
                #endif
                return true
            } catch  {
                fatalError("Cannot encode booksection to json")
            }
        }

    } else {
        // uuid does not exist
        return false
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return decoded
    }
}

extension UIImage {
    func scaledDown(into size:CGSize, centered:Bool = false) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleW, scaleH) = (1 as CGFloat, 1 as CGFloat)
        if targetWidth > size.width {
            scaleW = size.width/targetWidth
        }
        if targetHeight > size.height {
            scaleH = size.height/targetHeight
        }
        let scale = min(scaleW,scaleH)
        targetWidth *= scale; targetHeight *= scale
        let sz = CGSize(width:targetWidth, height:targetHeight)
        if !centered {
            return UIGraphicsImageRenderer(size:sz).image { _ in
                self.draw(in:CGRect(origin:.zero, size:sz))
            }
        }
        let x = (size.width - targetWidth)/2
        let y = (size.height - targetHeight)/2
        let origin = CGPoint(x:x,y:y)
        return UIGraphicsImageRenderer(size:size).image { _ in
            self.draw(in:CGRect(origin:origin, size:sz))
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

struct Symbol {
    enum Kind { case mention, hashtag }
    
    let kind: Kind
    var string: String
}

extension Symbol {
    static func mention(_ string: String) -> Symbol {
        return Symbol(kind: .mention, string: string)
    }
    
    static func hashtag(_ string: String) -> Symbol {
        return Symbol(kind: .hashtag, string: string)
    }
}

extension String {
    var mentionedUsernames: [String] {
        let parts = split(separator: ",")
        
        // Character sets may be inverted to identify all
        // characters that are *not* a member of the set.
        let delimiterSet = CharacterSet.letters.inverted
        
        return parts.compactMap { part in
            // Here we grab the first sequence of letters right
            let name = part.components(separatedBy: delimiterSet)[0]
            return name.isEmpty ? nil : name
        }
    }
}

extension FileManager {
    func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}

extension FileManager {
    func constructAllSections() -> [BookSection] {
        
        var myReturn: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + json).sorted(by: {$0.name < $1.name})
        myReturn = bookSections
        let test = FileManager.default.directoryExists(atUrl: myReczipesDirUrl)
        if !test {
            do {
                try FileManager.default.createDirectory(at: myReczipesDirUrl, withIntermediateDirectories: true)
                
                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: msgs.rnotes.rawValue), withIntermediateDirectories: true)
                
                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: msgs.rimages.rawValue), withIntermediateDirectories: true)
                
#if DEBUG
                print("FileManager: " + " Created Reczipes directory")
                print("FileManager: " + " Created RecipeNotes directory")
                print("FileManager: " + " Created RecipeImages directory")
#endif
                
            } catch {
                fatalError("Cannot create directories")
            }
        }
        do {
            
            var urls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(recipesName), includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            // skip these folders
            urls = urls.filter({!$0.pathComponents.contains(msgs.rnotes.rawValue)})
            urls = urls.filter({!$0.pathComponents.contains(msgs.rimages.rawValue)})
            
            
            for aurl in urls {
                do {
                    let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(aurl.lastPathComponent))
                    let aBookSection = try decoder.decode(BookSection.self, from: data)
                    // may need to merge recipes if multiple booksections with same name, different id exist
#if DEBUG
                    print(msgs.ci.rawValue + msgs.fuar.rawValue)
#endif
                    if myReturn.contains(where: {$0.name == aBookSection.name}) {
                        var existing = myReturn.first(where: {$0.name == aBookSection.name})
                        existing?.items.append(contentsOf: aBookSection.items)
                        // let idx = myReturn.firstIndex(where: {$0.name == aBookSection.name})
                        myReturn = myReturn.filter({$0.name != aBookSection.name})
                        if (existing != nil) {
                            myReturn.append(existing!)
#if DEBUG
                    print(msgs.ci.rawValue + msgs.combined.rawValue)
                            
#endif
                        }
                    } else {
                        myReturn.append(aBookSection)
                    }

                } catch  {
                    // not a json file
                    fatalError("This directory has illegal files")
                }
            }
        } catch  {
            // no contents or does not exist
        }
        
        return myReturn
    }
}



extension FileManager {
    func constructAllRecipes() -> [SectionItem] {
        var myReturn: [SectionItem] = []
        let myBs: [BookSection] = self.constructAllSections()
        if myBs.isEmpty {
            
        } else {
            for abs in myBs {
                myReturn.append(contentsOf: abs.items)
            }
        }
        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + json).sorted(by: {$0.name < $1.name})
        if bookSections.isEmpty  {
            
        } else {
            for abs in bookSections {
                myReturn.append(contentsOf: abs.items)
            }
        }
        
        let bs = constructAllSections()
        for abs in bs {
            myReturn.append(contentsOf: abs.items)
        }
        return myReturn
    }
}

extension FileManager {
    func saveBookSection(bsection: BookSection) -> Bool {
        var myReturn: Bool = false
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        do {
            let encodedJSON = try encoder.encode(bsection)
            // now write out
            try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(bsection.name + "_" + dateSuffix() + json))
            #if DEBUG
            print("Successfully wrote booksection to reczipes directory")
            #endif
            myReturn = true
       
        } catch {
            // can't save
        }
        return myReturn
    }
}

extension FileManager {
    func constructUserSavedRecipesIfAvailable() -> [SectionItem] {
        var mySavedRecipes:Array<SectionItem> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        
        do {
            var recipesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            recipesUrls = recipesUrls.filter({$0.lastPathComponent != recipeNotesFolderName})
            recipesUrls = recipesUrls.filter({$0.lastPathComponent != recipeImagesFolderName})
            
#if DEBUG
            print(msgs.ci.rawValue + " User added recipes Contents count " + "\(recipesUrls.count)")
#endif
            for arecipeurl in recipesUrls {
                let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(arecipeurl.lastPathComponent))
                let decodedJSON = try decoder.decode(SectionItem.self, from: data)
                mySavedRecipes.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from notes")
        }
        return mySavedRecipes
    }
}

extension FileManager {
    func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        
        do {
            let notesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
#if DEBUG
            print(msgs.ci.rawValue + " User added Notes Contents count " + "\(notesUrls.count)")
#endif
            for anoteurl in notesUrls {
                let data = try Data(contentsOf: myNotesDirUrl.appendingPathComponent(anoteurl.lastPathComponent))
                let decodedJSON = try decoder.decode(Note.self, from: data)
                myNotesConstructed.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from notes")
        }
        
        let shippedNotes:[Note] = Bundle.main.decode([Note].self, from: "Notes.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        if shippedNotes.isEmpty  {
#if DEBUG
            print(msgs.ci.rawValue + " shipped Notes Contents count " + "\(shippedNotes.count)")
#endif
        } else {
            myNotesConstructed.append(contentsOf: shippedNotes)
        }
        
        if myNotesConstructed.count == 0 {
#if DEBUG
            print(msgs.ci.rawValue + " No User recipe notes")
#endif
        } else {
#if DEBUG
            print(msgs.ci.rawValue + " User recipe notes exist: " + " \(myNotesConstructed.count)")
#endif
        }
        return myNotesConstructed
    }
}

extension FileManager {
    func constructImagesIfAvailable() -> Array<ImageSaved> {
        var myImagesConstructed:Array<ImageSaved> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
        do {
            let imagesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myImagesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
#if DEBUG
            print(msgs.ci.rawValue + " User added Images Contents count " + "\(imagesUrls.count)")
#endif
            for anImageUrl in imagesUrls {
                let data = try Data(contentsOf: myImagesDirUrl.appendingPathComponent(anImageUrl.lastPathComponent))
                let decodedJSON = try decoder.decode(ImageSaved.self, from: data)
                myImagesConstructed.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from images")
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: "Images.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        if shippedImages.isEmpty  {
#if DEBUG
            print(msgs.ci.rawValue + " shipped Images Contents count " + "\(shippedImages.count)")
#endif
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
        }
        
        if myImagesConstructed.count == 0 {
#if DEBUG
            print(msgs.ci.rawValue + " No user images")
#endif
        } else {
#if DEBUG
            print(msgs.ci.rawValue + " User images exist: " + " \(myImagesConstructed.count)")
#endif
        }
        return myImagesConstructed
    }
}

extension FileManager {
    func removeAddedRecipes() {
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        do {
            let sectionUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            for aPath in sectionUrls {
                do {
                    try FileManager.default.removeItem(at: aPath)
                } catch  {
#if DEBUG
            print(msgs.ci.rawValue + " Couldn't delete booksection")
#endif
                }
            }
        } catch   {
             // no files
#if DEBUG
            print(msgs.ci.rawValue + " no booksection files found")
#endif
        }
    }
}

extension Publisher {
  
  /// Executes an asyncronous call and returns its result to the downstream subscriber.
  ///
  /// - Parameter transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
  /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
  func `await`<T>(_ transform: @escaping (Output) async -> T) -> AnyPublisher<T, Failure> {
    flatMap { value -> Future<T, Failure> in
      Future { promise in
        Task {
          let result = await transform(value)
          promise(.success(result))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  /// Performs the specified closures when publisher events occur.
  ///
  /// This is an overloaded version of ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` that only
  /// accepts a closure for the `receiveOutput` events. Use it to inspect events as they pass through the pipeline.
  ///
  /// - Parameters:
  ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
  /// - Returns: A publisher that performs the specified closures when publisher events occur.
  func handleEvents(_ receiveOutput: (@escaping (Self.Output) -> Void)) -> Publishers.HandleEvents<Self> {
    self.handleEvents(receiveOutput: receiveOutput)
  }
  
  /// Performs the specified closures when publisher events occur.
  ///
  /// This is an overloaded version of ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` that only
  /// accepts a closure for the `receiveOutput` events. Use it to execute side effects while events pass down the pipeline.
  ///
  /// - Parameters:
  ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
  /// - Returns: A publisher that performs the specified closures when publisher events occur.
  func handleEvents(_ receiveOutput: (@escaping () -> Void)) -> Publishers.HandleEvents<Self> {
    self.handleEvents { output in
      receiveOutput()
    }
  }
}
