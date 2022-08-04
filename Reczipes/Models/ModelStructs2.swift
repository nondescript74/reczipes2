//
//  ModelStructs2.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/13/21.
//

import Foundation
import SwiftUI

struct ImageSaved: Codable, Equatable, Hashable {
    var recipeuuid: String
    var imageSaved: Data
    
    static func == (lhs: ImageSaved, rhs: ImageSaved) -> Bool {
        if lhs.recipeuuid == rhs.recipeuuid && lhs.imageSaved == rhs.imageSaved {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(recipeuuid)
        hasher.combine(imageSaved)
    }
    
    static let example1 = ImageSaved(recipeuuid: "3D4CDED8-51A3-46FB-8384-C48773B8B640", imageSaved: Data())
    static let example2 = ImageSaved(recipeuuid: "3D4CDED8-51A3-46FB-8384-C48773B8B640", imageSaved: Data())
}

struct Note: Codable, Equatable, Hashable {
    var recipeuuid: String
    var note:String
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        if lhs.recipeuuid == rhs.recipeuuid && lhs.note == rhs.note {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(recipeuuid)
        hasher.combine(note)
    }
    
    static let example1 = Note(recipeuuid: "3D4CDED8-51A3-46FB-8384-C48773B8B640", note: "First time, Z thought they were too tender. This time, tried 152F for 24 hours. ￼this temp was pretty perfect. Took about an hour to finish in the oven though.  Maybe a hotter oven for awhile next time.")
    static let example2 = Note(recipeuuid: "3D4CDED8-51A3-46FB-8384-C48773B8B640", note: "Just a note")
}

struct Notes: Codable, Equatable, Hashable {
    var notes: [Note]
    
    static func == (lhs: Notes, rhs: Notes) -> Bool {
        if lhs.notes == rhs.notes {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
    }
    
    static let example = Notes(notes: [Note.example1, Note.example2])
    
}

struct BookSectionIDName: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    var name: String
    
    static func == (lhs: BookSectionIDName, rhs: BookSectionIDName) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

struct BookSection: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var items: [SectionItem]
    
    static func == (lhs: BookSection, rhs: BookSection) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//struct BookSection2: Codable, Equatable, Identifiable, Hashable {
//    var id: UUID
//    var name: String
//    var items: [SecItemWBookName]
//
//    static func == (lhs: BookSection2, rhs: BookSection2) -> Bool {
//        if lhs.id == rhs.id {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}

//struct SecItemWBookName: Codable, Equatable, Identifiable, Hashable {
//    var id: UUID
//    var name: String
//    var url: String
//    var imageUrl: String?
//    var photocredit: String
//    var restrictions: [String]
//    var bookName: String
//
//    static func == (lhs: SecItemWBookName, rhs: SecItemWBookName) -> Bool {
//        if lhs.id == rhs.id {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
//    static let example = SecItemWBookName(id: UUID(uuidString: "DBCBD375-BDB1-43C3-A5DD-37850D639BC6")!, name: "Malai Kofta (Veggie Balls in a Thick Sauce)", url: "https://www.thespruceeats.com/malai-kofta-vege-balls-in-a-thick-sauce-1957964", imageUrl: nil, photocredit: "TheSpruceEats", restrictions: ["V", "G"], bookName: recipeBooks2[0])
//    static let example2 = SecItemWBookName(id: UUID(uuidString: "BF37D8BD-3B0F-457F-BD5A-A2DA158D52AB")!, name: "Kenji Mapo Tofu Z likes", url: "https://www.seriouseats.com/recipes/2011/07/real-deal-mapo-dofu-tofu-chinese-sichuan-recipe.html", imageUrl: nil, photocredit: "Kenji Lopez-Alt", restrictions: ["G"], bookName: recipeBooks2[0])
//    static let example3 = SecItemWBookName(id: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, name: "Sous Vide Barbecue Pork Ribs", url: "https://www.seriouseats.com/recipes/2015/09/sous-vide-pork-ribs-recipe-food-lab.html", imageUrl: nil, photocredit: "Kenji Lopez-Alt", restrictions: ["G"], bookName: recipeBooks2[0])
//}

struct SectionItemNotesImages: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var recipeData: Data
    var recipeImages: Data
    var recipeNotes: Data
    
    static func == (lhs: SectionItemNotesImages, rhs: SectionItemNotesImages) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SectionItem: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var url: String
    var imageUrl: String?
    var photocredit: String
    var restrictions: [String]
    
    var mainImage: String {
        name
    }
    
    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let example = SectionItem(id: UUID(uuidString: "DBCBD375-BDB1-43C3-A5DD-37850D639BC6")!, name: "Malai Kofta (Veggie Balls in a Thick Sauce)", url: "https://www.thespruceeats.com/malai-kofta-vege-balls-in-a-thick-sauce-1957964", imageUrl: "https://www.thespruceeats.com/thmb/CqOsksWGW3IfPYyyHFDCTCk1v18=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/malai-kofta-vege-balls-in-a-thick-sauce-1957964-hero-01-f8bad63cc4874630b02d7335208129d9.jpg", photocredit: "TheSpruceEats", restrictions: ["V", "G"])
    static let example2 = SectionItem(id: UUID(uuidString: "BF37D8BD-3B0F-457F-BD5A-A2DA158D52AB")!, name: "Kenji Mapo Tofu Z likes", url: "https://www.seriouseats.com/recipes/2011/07/real-deal-mapo-dofu-tofu-chinese-sichuan-recipe.html", imageUrl: "https://www.seriouseats.com/thmb/j297rvce95ZKXcl0IAtCQeAa4DE=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2011__07__2021-02-12-Mapo-Tofu-MHOM-10-804db1211f1d47dbae505341d1e7b994.jpg", photocredit: "Kenji Lopez-Alt", restrictions: ["G"])
    static let example3 = SectionItem(id: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, name: "Sous Vide Barbecue Pork Ribs", url: "https://www.seriouseats.com/recipes/2015/09/sous-vide-pork-ribs-recipe-food-lab.html", imageUrl: "https://www.seriouseats.com/thmb/1KFWweU6yYJCd4f8vbiQmiYT-3I=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__recipes__images__2015__08__20150730-anova-sous-vide-rib-guide-food-lab68-j-kenji-lopez-alt-3a8181cad15d4dbc93037b66c0f209da.jpg", photocredit: "Kenji Lopez-Alt", restrictions: ["G"])
    
}

struct Measures: Codable, Hashable, Equatable {
    var us:Measure?
    var metric:Measure?
    
    static func == (lhs: Measures, rhs: Measures) -> Bool {
        if lhs.us?.amount == rhs.us?.amount {
            return true
        } else {
            return false
        }
    }
    static let measuresExample = Measures(us: Measure.measureExampleUS, metric: Measure.measureExampleMetric)
}

struct Measure: Codable, Hashable, Equatable {
    var amount:Double?
    var unitShort:String?
    var unitLong:String?
    
    static func == (lhs: Measure, rhs: Measure) -> Bool {
        if lhs.amount == rhs.amount && lhs.unitShort == rhs.unitShort && lhs.unitLong == rhs.unitLong {
            return true
        } else {
            return false
        }
    }
    static let measureExampleUS =  Measure(amount: 3.968, unitShort: "lb", unitLong: "pounds")
    static let measureExampleMetric =  Measure(amount: 1.8, unitShort: "kg", unitLong: "kilograms")
}

struct ExtendedIngredientSet: Codable, Hashable, Equatable {
    var extendedIngredients:[ExtendedIngredient?]?
    
    static func == (lhs: ExtendedIngredientSet, rhs: ExtendedIngredientSet) -> Bool {
        if lhs.extendedIngredients == rhs.extendedIngredients {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(extendedIngredients)
    }
    static let extendedIngredientSetExample = ExtendedIngredientSet(extendedIngredients: Bundle.main.decode(ExtendedIngredientSet.self, from: "ExtendedIngredients.json").extendedIngredients)
}

struct ExtendedIngredient: Codable, Hashable, Identifiable, Equatable {
    var id:Int64?
    var aisle:String?
    var image:String?
    var consistency:String?
    var name:String?
    var original:String?
    var originalString:String?
    var originalName:String?
    var amount:Double?
    var unit:String?
    var meta:[String?]?
    var metaInformation:[String?]?
    var measures:Measures?
    
    
    static func == (lhs: ExtendedIngredient, rhs: ExtendedIngredient) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let extendedIngredientExample = ExtendedIngredient(id: 11507,
                                                              aisle: "Produce",
                                                              image: "sweet-potato.png",
                                                              consistency: "solid",
                                                              name: "moist sweet potatoes",
                                                              original: "4 pounds (1.8kg) moist sweet potatoes, such as ruby or garnet yams (about 4 large potatoes; see note)",
                                                              originalString: "4 pounds (1.8kg) moist sweet potatoes, such as ruby or garnet yams (about 4 large potatoes; see note)",
                                                              originalName: "pounds moist sweet potatoes, such as ruby or garnet yams (about 4 large potatoes; see note)",
                                                              amount: 1.8,
                                                              unit: "kg",
                                                              meta: [" such as ruby or garnet yams ( 4 large potatoes; see note)"],
                                                              metaInformation: [" such as ruby or garnet yams ( 4 large potatoes; see note)"],
                                                              measures: Measures.measuresExample
    )
}

struct ProductMatch: Codable, Hashable, Identifiable, Equatable {
    var id: Int64?
    var title: String?
    var description: String?
    var price: String? // currency
    var imageUrl: String?
    var averageRating: Double?
    var ratingCount: Double?
    var score: Double?
    var link: String?
    
    static func == (lhs: ProductMatch, rhs: ProductMatch) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}

struct WinePairing: Codable, Hashable, Equatable  {
    var pairedWines:[String]?
    var pairingText:String?
    var productMatches:[ProductMatch?]?
    
    static func == (lhs: WinePairing, rhs: WinePairing) -> Bool {
        if lhs.productMatches == rhs.productMatches {
            return true
        } else {
            return false
        }
    }
}

struct Ingredient: Codable, Hashable, Identifiable, Equatable {
    var id: Int64?
    var name: String?
    var localizedName: String?
    var image: String?
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        if lhs.id == rhs.id && lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}

struct Temperature:  Codable, Hashable, Equatable {
    var number: Double
    var unit: String
    static func == (lhs: Temperature, rhs: Temperature) -> Bool {
        if lhs.number == rhs.number && lhs.unit == rhs.unit {
            return true
        } else {
            return false
        }
    }
}

struct Equipment: Codable, Hashable, Equatable {
    var id:Int64?
    var name:String?
    var localizedName:String?
    var image:String?
    var temperature:Temperature?
    static func == (lhs: Equipment, rhs: Equipment) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}

struct Step: Codable, Hashable, Equatable {
    var number: Int64?
    var step: String?
    var ingredients:[Ingredient?]?
    var equipment:[Equipment?]?
    var length:Length?
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        if lhs.step == rhs.step && lhs.number == rhs.number {
            return true
        } else {
            return false
        }
    }
}

struct Length: Codable, Hashable, Equatable {
    var number:Double?
    var unit:String?
    
    static func == (lhs: Length, rhs: Length) -> Bool {
        if lhs.number == rhs.number && lhs.unit == rhs.unit {
            return true
        } else {
            return false
        }
    }
}

struct AnalyzedInstructions: Codable, Hashable, Equatable {
    var name: String?
    var steps: [Step?]?
}

struct SRecipeGroup: Codable  {
    var results:[SRecipe]?  // when using random
    var recipes:[SRecipe]?  //when using find
}

struct SRecipe: Codable, Hashable, Identifiable, Equatable {
    var aggregateLikes:Int64?
    var analyzedInstructions:[AnalyzedInstructions?]?
    var cheap:Bool?
    var cookingMinutes:Int64?
    var creditsText:String?
    var cuisines:[String?]?
    var dairyFree:Bool?
    var diets:[String?]?
    var dishTypes:[String?]?
    var extendedIngredients:[ExtendedIngredient?]?
    var gaps:String?
    var glutenFree:Bool?
    var healthScore:Double?
    var id:Int64?
    var image:String?
    var imageType:String?
    var instructions:String?
    var license:String?
    var lowFodmap:Bool?
    var occasions:[String?]?
    var originalId:String?
    var preparationMinutes:Int64?
    var pricePerServing:Double?
    var readyInMinutes:Int64?
    var servings:Int64?
    var sourceName:String?
    var sourceUrl:String?
    var spoonacularScore:Double?
    var spoonacularSourceUrl:String?
    var summary:String?
    var sustainable:Bool?
    var title:String?
    var vegan:Bool?
    var vegetarian:Bool?
    var veryHealthy:Bool?
    var veryPopular:Bool?
    var weightWatcherSmartPoints:Int64?
    var winePairing:WinePairing?
    
    
    static func == (lhs: SRecipe, rhs: SRecipe) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    static let example = Bundle.main.decode(SRecipe.self, from: "SRecipeExample.json")
}

struct Trivia: Codable, Hashable, Equatable {
    var text:String
    
    static func == (lhs: Trivia, rhs: Trivia) -> Bool {
        if lhs.text == rhs.text {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}

struct Joke: Codable, Hashable, Equatable {
    var text:String
    
    static func == (lhs: Joke, rhs: Joke) -> Bool {
        if lhs.text == rhs.text {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}
