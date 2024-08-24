//
//  ModelStructs2.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/13/21.
//

import Foundation
import SwiftUI


struct ImageSaved: Codable, Equatable, Hashable {
    var recipeuuid: UUID
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
    
    static let example1 = ImageSaved(recipeuuid: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, imageSaved: Data())
    static let example2 = ImageSaved(recipeuuid: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, imageSaved: Data())
}

struct Note: Codable, Equatable, Hashable {
    var recipeuuid: UUID
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
    
    
    static let example1 = Note(recipeuuid: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, note: "First time, Z thought they were too tender. This time, tried 152F for 24 hours. ￼this temp was pretty perfect. Took about an hour to finish in the oven though.  Maybe a hotter oven for awhile next time.")
    static let example2 = Note(recipeuuid: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, note: "Just a note")
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
    var items: [SectionItem3]
    
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
    
    static let example = BookSection(id: UUID(uuidString: "29E93882-20A2-47A5-8BA0-2B81B7898BFC")!, name: "Other", items: [])
}


struct SectionItemNotesImages: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var recipeData: Data  // sectionItem
    var recipeImages: Data  //
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

struct SectionItem3: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    var recipeId: Int?
    var name: String
    var url: String
    var imageUrl: String?
    var photocredit: String
    var restrictions: [String]
    var summary: String?
    
    var mainImage: String {
        name
    }
    
    static func == (lhs: SectionItem3, rhs: SectionItem3) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static let example = SectionItem3(id: UUID(uuidString: "DBCBD375-BDB1-43C3-A5DD-37850D639BC6")!, recipeId: 9999981, name: "Malai Kofta (Veggie Balls in a Thick Sauce)", url: "https://www.thespruceeats.com/malai-kofta-vege-balls-in-a-thick-sauce-1957964", imageUrl: "https://www.thespruceeats.com/thmb/CqOsksWGW3IfPYyyHFDCTCk1v18=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/malai-kofta-vege-balls-in-a-thick-sauce-1957964-hero-01-f8bad63cc4874630b02d7335208129d9.jpg", photocredit: "TheSpruceEats", restrictions: ["Vegetarian", "Gluten Free"], summary: "There is no summary for the example1")
    static let example2 = SectionItem3(id: UUID(uuidString: "BF37D8BD-3B0F-457F-BD5A-A2DA158D52AB")!, recipeId: 9999982, name: "Kenji Mapo Tofu Z likes", url: "https://www.seriouseats.com/recipes/2011/07/real-deal-mapo-dofu-tofu-chinese-sichuan-recipe.html", imageUrl: "https://www.seriouseats.com/thmb/j297rvce95ZKXcl0IAtCQeAa4DE=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2011__07__2021-02-12-Mapo-Tofu-MHOM-10-804db1211f1d47dbae505341d1e7b994.jpg", photocredit: "Kenji Lopez-Alt", restrictions: ["Vegetarian", "Gluten Free"], summary: "There is no summary for the example2")
    static let example3 = SectionItem3(id: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, recipeId: 9999983, name: "Sous Vide Barbecue Pork Ribs", url: "https://www.seriouseats.com/recipes/2015/09/sous-vide-pork-ribs-recipe-food-lab.html", imageUrl: "https://www.seriouseats.com/thmb/1KFWweU6yYJCd4f8vbiQmiYT-3I=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__recipes__images__2015__08__20150730-anova-sous-vide-rib-guide-food-lab68-j-kenji-lopez-alt-3a8181cad15d4dbc93037b66c0f209da.jpg", photocredit: "Kenji Lopez-Alt", restrictions: ["Gluten Free", "Whole30"], summary: "There is no summary for the example3")
}


//struct SectionItem2: Codable, Equatable, Identifiable, Hashable {
//    var id: UUID
//    var recipeId: Int?
//    var name: String
//    var url: String
//    var imageUrl: String?
//    var photocredit: String
//    var restrictions: [String]
//    
//    var mainImage: String {
//        name
//    }
//    
//    static func == (lhs: SectionItem2, rhs: SectionItem2) -> Bool {
//        if lhs.name == rhs.name {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//    }
//    
//    static let example = SectionItem2(id: UUID(uuidString: "DBCBD375-BDB1-43C3-A5DD-37850D639BC6")!, recipeId: 9999981, name: "Malai Kofta (Veggie Balls in a Thick Sauce)", url: "https://www.thespruceeats.com/malai-kofta-vege-balls-in-a-thick-sauce-1957964", imageUrl: "https://www.thespruceeats.com/thmb/CqOsksWGW3IfPYyyHFDCTCk1v18=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/malai-kofta-vege-balls-in-a-thick-sauce-1957964-hero-01-f8bad63cc4874630b02d7335208129d9.jpg", photocredit: "TheSpruceEats", restrictions: ["Vegetarian", "Gluten Free"])
//    static let example2 = SectionItem2(id: UUID(uuidString: "BF37D8BD-3B0F-457F-BD5A-A2DA158D52AB")!, recipeId: 9999982, name: "Kenji Mapo Tofu Z likes", url: "https://www.seriouseats.com/recipes/2011/07/real-deal-mapo-dofu-tofu-chinese-sichuan-recipe.html", imageUrl: "https://www.seriouseats.com/thmb/j297rvce95ZKXcl0IAtCQeAa4DE=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2011__07__2021-02-12-Mapo-Tofu-MHOM-10-804db1211f1d47dbae505341d1e7b994.jpg", photocredit: "Kenji Lopez-Alt", restrictions: ["Vegetarian", "Gluten Free"])
//    static let example3 = SectionItem2(id: UUID(uuidString: "3D4CDED8-51A3-46FB-8384-C48773B8B640")!, recipeId: 9999983, name: "Sous Vide Barbecue Pork Ribs", url: "https://www.seriouseats.com/recipes/2015/09/sous-vide-pork-ribs-recipe-food-lab.html", imageUrl: "https://www.seriouseats.com/thmb/1KFWweU6yYJCd4f8vbiQmiYT-3I=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__recipes__images__2015__08__20150730-anova-sous-vide-rib-guide-food-lab68-j-kenji-lopez-alt-3a8181cad15d4dbc93037b66c0f209da.jpg", photocredit: "Kenji Lopez-Alt", restrictions: ["Gluten Free", "Whole30"])
//}

struct Restriction: Codable, Hashable, Equatable {
    var name: String
    var description: String
    
    static func == (lhs: Restriction, rhs: Restriction) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
    static let restrictionExample = Restriction(name: "Whole30",
                                                description: "Allowed ingredients include meat, fish/seafood, eggs, vegetables, fresh fruit, coconut oil, olive oil, small amounts of dried fruit and nuts/seeds. Ingredients not allowed include added sweeteners (natural and artificial, except small amounts of fruit juice), dairy (except clarified butter or ghee), alcohol, grains, legumes (except green beans, sugar snap peas, and snow peas), and food additives, such as carrageenan, MSG, and sulfites.")
    
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
    var id:Int?
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
    var id: Int?
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
    var id: Int
    var name: String
    var localizedName: String?
    var image: String?
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        if lhs.id == rhs.id && lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
    
    static let ingredientExample = Ingredient(id: 1145, name: "unsalted butter")
    static let ingredientExample1 = Ingredient(id: 19335, name: "sugar")
    
    static let ingredientSet1: [Ingredient] =
    [Ingredient(id: 1102047, name: "salt and pepper",localizedName: "salt and pepper", image: "salt-and-pepper.jpg"),
     Ingredient(id: 6172, name: "chicken stock",localizedName: "chicken stock", image: "chicken-broth.png"),
     Ingredient(id:4047, name:"coconut oil",localizedName:"coconut oil",image:"oil-coconut.jpg"),
     Ingredient(id:20035, name:"quinoa",localizedName:"quinoa",image:"uncooked-quinoa.png"),
     Ingredient(id:1019016, name:"juice",localizedName:"juice",image:"apple-juice.jpg"),
     Ingredient(id:9159, name:"lime",localizedName:"lime",image:"lime.jpg")]
    
    static let ingredientSet2: [Ingredient] =
    [Ingredient(id:4047, name:"coconut oil",localizedName:"coconut oil",image:"oil-coconut.jpg"),
     Ingredient(id:20035, name:"quinoa",localizedName:"quinoa",image:"uncooked-quinoa.png")]
    
    static let ingredientSet3: [Ingredient] =
    [Ingredient(id:10111333, name:"peppers",localizedName:"peppers",image:"green-pepper.jpg"),
     Ingredient(id:11282, name:"onion",localizedName:"onion",image:"brown-onion.png")]
    
    /*
     {
     "id": 93830,
     "name": "mirin",
     "localizedName": "mirin",
     "image": "mirin.jpg"
     }
     */
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
    var id:Int
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
    
    static let equipmentExample = Equipment(id: Int.random(in: 0..<999999), name: "9 inch iron skillet")
    static let equipmentExample1 = Equipment(id: 404669, name: "sauce pan", image: "sauce-pan.jpg")
    static let equipmentExample2 = [Equipment(id:404666,name:"wok",localizedName:"wok",image:"wok.png")]
    
    static let equipmentSet1: [Equipment] = [equipmentExample, equipmentExample1]
    static let equipmentSet3: [Equipment] = []
    
    /*
     {
     "id": 404669,
     "name": "sauce pan",
     "localizedName": "sauce pan",
     "image": "sauce-pan.jpg"
     },
     {
     "id": 404752,
     "name": "pot",
     "localizedName": "pot",
     "image": "stock-pot.jpg"
     }
     */
}

//
//
//// MARK: - Step
//struct Step: Codable, Equatable, Hashable {
//    let number: Int
//    let step: String
//    let ingredients, equipment: [Ent]
//    let length: Length?
//    
//        static func == (lhs: Step, rhs: Step) -> Bool {
//            if lhs.step == rhs.step && lhs.number == rhs.number {
//                return true
//            } else {
//                return false
//            }
//        }
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(number)
//        hasher.combine(step)
//    }
//}

//// MARK: - Ent
//struct Ent: Codable, Equatable, Hashable {
//    let id: Int
//    let name, localizedName: String
//    let image: String
//    let temperature: Length?
//    
//    static func == (lhs: Ent, rhs: Ent) -> Bool {
//        if lhs.id == rhs.id && lhs.name == rhs.name {
//            return true
//        } else {
//            return false
//        }
//    }
//public func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//    hasher.combine(name)
//}
//}

// MARK: - Length
//struct Length: Codable {
//    let number: Int
//    let unit: String
//}

//typealias Welcome = [WelcomeElement]

//struct Step: Codable, Hashable, Equatable {
//    var number: Int
//    var step: String
//    var ingredients:[Ingredient?]?
//    var equipment:[Equipment?]?
//    var length:Length?
//    
//    static func == (lhs: Step, rhs: Step) -> Bool {
//        if lhs.step == rhs.step && lhs.number == rhs.number {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    static let stepExample = Step(number: 1, 
//                                  step: "In a medium saucepan, add the quinoa and chicken stock. Bring to boil over medium high heat. Once boiling, reduce heat to low and cover pot. Cook until all the liquid is absorbed, about 15 minutes. Stir in the coconut oil, juice and zest of lime, salt and pepper.",
//                                  ingredients: Ingredient.ingredientSet1,
//                                  equipment: Equipment.equipmentSet1,
//                                  length: Length.lengthMinutesExample1)
//    static let stepExample2 = Step(number: 2,
//                                  step: "Let quinoa cool completely before using. You can do this ahead of time or the day before.In a large wok, heat one tablespoon coconut oil over medium heat.",
//                                  ingredients: Ingredient.ingredientSet2,
//                                   equipment: Equipment.equipmentSet3)
//    static let stepExample3 = Step(number: 3,
//                                  step: "Add in onions and peppers and cook until soft, about 2 minutes.",
//                                  ingredients: Ingredient.ingredientSet3,
//                                  equipment: Equipment.equipmentSet3,
//                                  length: Length.lengthMinutesExample3)
//    
//    
//    static let stepExample21 = Step(number: 2, step: "Prepare ingredients", ingredients: [Ingredient.ingredientExample, Ingredient.ingredientExample1], equipment: [Equipment.equipmentExample], length: Length.lengthSecondsExample)
//    static let stepExample22 = Step(number: 3, step: "Prepare ingredients", ingredients: [Ingredient.ingredientExample, Ingredient.ingredientExample1], equipment: [Equipment.equipmentExample], length: Length.lengthSecondsExample)
//}

//struct Length: Codable, Hashable, Equatable {
//    var number:Int
//    var unit:String
//    
//    static func == (lhs: Length, rhs: Length) -> Bool {
//        if lhs.number == rhs.number && lhs.unit == rhs.unit {
//            return true
//        } else {
//            return false
//        }
//    }
////    static let lengthSecondsExample = Length(number: 10, unit: "seconds")
////    static let lengthMinutesExample1 = Length(number: 15, unit: "minutes")
////    static let lengthMinutesExample3 = Length(number: 2, unit: "minutes")
//}
//
////struct Instruction: Codable, Hashable, Identifiable {
////    var id: Int64
////    var text: String
////    
////    static func == (lhs: Instruction, rhs: Instruction) -> Bool {
////        if lhs.id == rhs.id && lhs.text == rhs.text {
////            return true
////        } else {
////            return false
////        }
////    }
////}


// MARK: - TopLevelElement
struct AnalyzedInstructions: Codable {
    let name: String
    let steps: [Step]
}

// MARK: - Step
struct Step: Codable, Equatable, Hashable  {
    let number: Int
    let step: String
    let ingredients, equipment: [Ent]
    let length: Length?
    
    static func == (lhs: Step, rhs: Step) -> Bool {
            if lhs.number == rhs.number && lhs.step == rhs.step  {
                return true
            } else {
                return false
            }
        }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(step)
    }
}

// MARK: - Ent
struct Ent: Codable {
    let id: Int
    let name, localizedName, image: String
}

// MARK: - Length
struct Length: Codable {
    let number: Int
    let unit: String
}
//
//struct AnalyzedInstructions: Codable {
//    let analyzedInstructions: [AnalyzedInstruction]
//}
//
//struct AnalyzedInstruction: Codable, Equatable, Hashable {
//    let name: String
//    let steps: [Step]
//    
//    static func == (lhs: AnalyzedInstruction, rhs: AnalyzedInstruction) -> Bool {
//        if lhs.name == rhs.name && lhs.steps == rhs.steps {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(steps)
//    }
    
//    static let analyzedInstructionExample = AnalyzedInstruction(name: "Analyzed Instructions Example", steps: [Step.stepExample, Step.stepExample2, Step.stepExample3])
//    static let analyzedInstructionExample2 = Bundle.main.decode(AnalyzedInstruction.self, from: "AnalyzedInstructionExample2.json")
//    static let analyzedInstructionExample3 = Bundle.main.decode(AnalyzedInstruction.self, from: "AnalyzedInstructionExample3.json")
//}

//struct AnalyzedInstructions: Codable, Equatable {
//    var id: UUID = UUID()
//    var setOfAnalyzedInstruction: [AnalyzedInstruction] = [AnalyzedInstruction]()
//    
//    static func == (lhs: AnalyzedInstructions, rhs: AnalyzedInstructions) -> Bool {
//        if (lhs.setOfAnalyzedInstruction == rhs.setOfAnalyzedInstruction) && (lhs.id == rhs.id) {
//            return true
//        } else {
//            return false
//        }
//    }
//    
////    static let analyzedInstructionsExample = AnalyzedInstructions(setOfAnalyzedInstruction: [AnalyzedInstruction.analyzedInstructionExample, AnalyzedInstruction.analyzedInstructionExample2])
//}
struct CRecipe: Identifiable, Codable, Hashable {
    /*
     id": 488633,
     "title": "gobi pakora , how to make gobi pakoras or cauliflower fritters",
     "image": "https://spoonacular.com/recipeImages/488633-312x231.jpg",
     "imageType": "jpg"
     */
    var id: Int
    var title: String
    var image: String
    var imageType: String
    
    static func == (lhs: CRecipe, rhs: CRecipe) -> Bool {
        if lhs.id == rhs.id && lhs.image == rhs.image {
            return true
        } else {
            return false
        }
    }

    static let cRecipeExample = CRecipe(id: 488633,
                                        title: "gobi pakora , how to make gobi pakoras or cauliflower fritters",
                                        image: "https://spoonacular.com/recipeImages/488633-312x231.jpg",
                                        imageType: "jpg"
    )
}

struct CRecipeGroup: Codable {
    var results: [CRecipe]?
}

struct SRecipeGroup: Codable  {
    var results:[SRecipe]?  // when using random
    var recipes:[SRecipe]?  //when using find
}


struct SRecipe: Codable, Identifiable, Equatable {
    var aggregateLikes:Int64?
    var analyzedInstructions:AnalyzedInstructions? //
    var cheap:Bool?
    var cookingMinutes:Int64?
    var creditsText:String?
    var cuisines:[String?]?
    var dairyFree:Bool?
    var diets:[String]?
    var dishTypes:[String?]?
    var extendedIngredients:[ExtendedIngredient?]?
    var gaps:String?
    var glutenFree:Bool?
    var healthScore:Double?
    var id:Int
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

struct Diet: Codable, Hashable, Equatable {
    var name: String
    var id: Int
    
    
    static func == (lhs: Diet, rhs: Diet) -> Bool {
        if lhs.name == rhs.name && lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static let dietExampleGF = Diet(name: "Gluten Free", id: 0)
    static let dietExampleKG = Diet(name: "Ketogenic", id: 1)
    static let dietExampleVeg = Diet(name: "Vegetarian ", id: 2)
    static let dietExampleLVeg = Diet(name: "Lacto Vegetarian", id: 3)
    static let dietExampleOVeg = Diet(name: "Ovo Vegetarian", id: 4)
    static let dietExamplePesc = Diet(name: "Pescatarian", id: 5)
    static let dietExampleVega = Diet(name: "Vegan", id: 6)
    static let dietExamplePaleo = Diet(name: "Paleo", id: 7)
    static let dietExamplePrimal = Diet(name: "Primal", id: 8)
    static let dietExampleLowFM = Diet(name: "Low FODMAP", id: 9)
    static let dietExampleW30 = Diet(name: "Whole 30", id: 10)
    static let dietExamplesAll = [dietExampleGF, dietExampleKG, dietExampleVeg, dietExampleW30, dietExamplePesc, dietExampleVega, dietExamplePaleo, dietExampleLVeg, dietExampleOVeg, dietExamplePrimal, dietExampleLowFM]
    
}

struct SectionName: Codable, Hashable, Equatable, Identifiable {
    var id:  UUID
    var name: String
    
    static func == (lhs: SectionName, rhs: SectionName) -> Bool {
        if lhs.id == rhs.id && lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
    static let example = SectionName(id: UUID(uuidString: "F4DA7B28-D403-4313-8AFF-E9645587C99E")!, name: "Beef")
}

struct Cuisine: Codable, Hashable, Equatable {
    var name: String
    
    static func == (lhs: Cuisine, rhs: Cuisine) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
