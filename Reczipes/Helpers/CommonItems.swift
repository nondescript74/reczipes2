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
    
    case returningpresetrecipes = "Returning Preset Recipes "
    case returningbooksectionssf = "Returning BookSections in single file"
    case rshipd = "recipesShipped"
    case rnotes = "RecipeNotes"
    case rimages = "RecipeImages"
    case fuar = "Found user added recipe"
    case ci = "CommonItems"
}

private var decoder: JSONDecoder = JSONDecoder()
private var encoder: JSONEncoder = JSONEncoder()


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
        myRestrictions.append("VeryP")
    }
    if (((srecipe.lowFodmap) != nil)  && (srecipe.lowFodmap) == true) {
        myRestrictions.append("LowFM")
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
    
    
    print(msgs.ci.rawValue + item.name)
    
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
//        let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
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
                myReturn.append(aBookSection)
#if DEBUG
                    print(msgs.ci.rawValue + msgs.fuar.rawValue)
#endif
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
