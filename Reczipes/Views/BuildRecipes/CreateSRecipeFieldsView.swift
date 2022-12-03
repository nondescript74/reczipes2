//
//  CreateSRecipeFieldsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/1/22.
//

import SwiftUI

struct CreateSRecipeFieldsView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Environment Variables
    @EnvironmentObject var rbb: RecipeBeingBuilt
    // MARK: - Initializer
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case en = "Enter recipe name"
        case al = "Aggregate likes"
        case chp = "Cheap?"
        case cm = "Cooking minutes"
        case cred = "Credits"
        case cuis = "Pick a cuisine"
        case cuisine = "Cuisine"
        case df = "Dairy Free?"
        case diet = "Diet"
        case gf = "Gluten Free?"
        case hs = "Healthscore"
    }

    @State fileprivate var recName: String = ""
    @State fileprivate var aggLikes: Int64 = 0
    @State fileprivate var selectionValues: [Int64] = Array(0...500)
    @State fileprivate var cheap: Bool = true
    @State fileprivate var cookmin: Int64 = 0
    @State fileprivate var creds: String = ""
    @State fileprivate var xection: Int = 0
    @State fileprivate var selectionValues2: [Int] = Array(0...getBookSectionNames().count - 1)
    @State fileprivate var dairyF: Bool = false
    @State fileprivate var cuisines: String = ""
    @State fileprivate var diets: String = ""
    @State fileprivate var gf: Bool = false
    @State fileprivate var hscore: Double = 0.0
    
    
    // MARK: - Methods
    fileprivate func saveIt() -> Bool {
        rbb.srecipe?.aggregateLikes = self.aggLikes
        rbb.srecipe?.cheap = self.cheap
        rbb.srecipe?.cookingMinutes = self.cookmin
        rbb.srecipe?.creditsText = self.creds
        rbb.srecipe?.dairyFree = self.dairyF
        rbb.srecipe?.cuisines = [getBookSectionNames()[xection]]
        rbb.srecipe?.diets = [self.diets]
        rbb.srecipe?.dishTypes = []
        rbb.srecipe?.extendedIngredients = []
        rbb.srecipe?.gaps = ""
        rbb.srecipe?.glutenFree = self.gf
        rbb.srecipe?.healthScore = self.hscore
        rbb.srecipe?.id = Int.random(in: 100001..<myMax)
        rbb.srecipe?.image = ""
        rbb.srecipe?.imageType = ""
        rbb.srecipe?.instructions = ""
        rbb.srecipe?.license = ""
        rbb.srecipe?.lowFodmap = false
        rbb.srecipe?.occasions = []
        rbb.srecipe?.originalId = ""
        rbb.srecipe?.preparationMinutes = 0
        rbb.srecipe?.pricePerServing = 0.0
        rbb.srecipe?.readyInMinutes = 0
        rbb.srecipe?.servings = 0
        rbb.srecipe?.sourceName = "Z"
        rbb.srecipe?.sourceUrl = ""
        rbb.srecipe?.spoonacularScore = 0
        rbb.srecipe?.spoonacularSourceUrl = ""
        rbb.srecipe?.summary = ""
        rbb.srecipe?.sustainable = false
        rbb.srecipe?.title = ""
        rbb.srecipe?.vegan = false
        rbb.srecipe?.vegetarian = false
        rbb.srecipe?.veryHealthy = false
        rbb.srecipe?.veryPopular = false
        rbb.srecipe?.weightWatcherSmartPoints = 0
        rbb.srecipe?.winePairing = WinePairing()
        
        if rbb.srecipe != nil {
            let sectionItem = convertSRecipeToSectionItem(srecipe: rbb.srecipe!)
            let result = addRecipeToBookSection(recipe: sectionItem, bookSectionUUID: getBookSectionIDForName(name: getBookSectionNames()[xection]))
            if !result {
                return false
            }
        } else {
            return false
        }
        return true
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField(msgs.en.rawValue, text: $recName)
                    Picker(msgs.al.rawValue, selection: $aggLikes) {
                        ForEach(selectionValues, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    HStack {
                        Text(msgs.chp.rawValue)
                        Button("Change", action:{cheap.toggle()}).buttonStyle(.bordered)
                    }
                    
                    Picker(msgs.cm.rawValue, selection: $cookmin) {
                        ForEach(selectionValues, id: \.self) {
                            Text("\($0) minutes")
                        }
                    }
                    TextField(msgs.cred.rawValue, text: $creds)
                    Picker(msgs.cuis.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(selectionValues2, id: \.self) { index in
                            Text("\(getBookSectionNames()[index])")
                        }
                    }
                    HStack {
                        Text(msgs.df.rawValue)
                        Button("Change", action:{dairyF.toggle()}).buttonStyle(.bordered)
                    }
                }
                Text(msgs.al.rawValue + " " + aggLikes.description)
                Text(msgs.chp.rawValue + " " + cheap.description)
                Text(msgs.cm.rawValue + " " + cookmin.description)
                Text(msgs.df.rawValue + " " + dairyF.description)
                
                Text(msgs.cuisine.rawValue + " " + cuisines)
                Text(msgs.diet.rawValue + " " + diets)
                
                Button("Save", action: {_ = saveIt()})
            }
        }
    }
}

struct CreateSRecipeFieldsView_Previews: PreviewProvider {
    static let rbb = RecipeBeingBuilt()
    static var previews: some View {
        CreateSRecipeFieldsView()
            .environmentObject(rbb)
    }
}

/*
 var aggregateLikes:Int64?
 var analyzedInstructions:[AnalyzedInstructions?]? //
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
 */
