//
//  CommonItems.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/13/21.
//

import UIKit
import SwiftUI
import Foundation

public var colorFontLists:Color = Color.init("ED7D3A")
public var iPhoneXrPreviewDevice:PreviewDevice = "iPhone Xr"
public var iPadAir2PreviewDevice:PreviewDevice = "iPad Air 2"
public let spoonacular:String = "Spoonacular"
public let recipeFolderName = "RecipeFolder"
public let recipesName = "Recipes"
public let recipeNotesFolderName = "RecipeNotesFolder"
public let recipeImagesFolderName = "RecipeImagesFolder"
//public var recipeBooks:[String] = ["CRecipeBook0", "IndianRecipes0", "Added Recipes"]
//public var recipeBooks2:[String] = ["Carol", "Indian", "Added", "Diane", "Z", "Rafiq", "Chinese"]
let myBookSectionsIdNames: [BookSectionIDName] = Bundle.main.decode([BookSectionIDName].self, from: "SectionNames.json")

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
let imageSuitSpadeFill = UIImage(systemName: "suite.spade.fill")
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

fileprivate enum msgs: String {
    case json = "json"
    case returningpresetrecipes = "Returning Preset Recipes "
    case returningbooksectionssf = "Returning BookSections in single file"
    case recipesFile = "recipesShipped"
    case csrtsi = "Converted SRecipe to SectionItem"
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
        myRestrictions.append("VeryP")
    }
    if (((srecipe.lowFodmap) != nil)  && (srecipe.lowFodmap) == true) {
        myRestrictions.append("LowFM")
    }
    return myRestrictions
}

func getBookSectionsInFile(filename: String) -> [BookSection] {
    let bookSections1 = Bundle.main.decode([BookSection].self, from: filename + delimiterFiletype + msgs.json.rawValue).sorted(by: {$0.name < $1.name})
    
#if DEBUG
    print(msgs.returningbooksectionssf.rawValue + bookSections1.count.description)
#endif
    
    return bookSections1
}

func getAllPresetRecipes() -> [SectionItem]  {
    var myReturningRecipes:[SectionItem] = []
    let bookSections0 = Bundle.main.decode([BookSection].self, from: msgs.recipesFile.rawValue + delimiterFiletype + msgs.json.rawValue).sorted(by: {$0.name < $1.name})
    for aSection in bookSections0 {
        myReturningRecipes.append(contentsOf: aSection.items)
    }

    
#if DEBUG
    print(msgs.returningpresetrecipes.rawValue + myReturningRecipes.count.description)
#endif
    return myReturningRecipes
}



func convertSRecipeToSectionItem(srecipe: SRecipe) -> SectionItem {
    let item = SectionItem(id: UUID(),
                            name: srecipe.title ?? SectionItem.example.name,
                            url: srecipe.sourceUrl ?? SectionItem.example.url,
                            imageUrl: srecipe.image,
                            photocredit: srecipe.creditsText ?? SectionItem.example.photocredit,
                            restrictions: constructRestrictions(srecipe: srecipe))
    
#if DEBUG
    print(msgs.csrtsi.rawValue + item.name)
#endif
    return item
}

func getBookSectionNames() -> [String] {
    var returningNames:[String] = []
    let idNameArray = myBookSectionsIdNames
    for aIdName in idNameArray {
        returningNames.append(aIdName.name)
    }
    let sortedNames = returningNames.sorted(by: {$0 < $1})
    return sortedNames
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
