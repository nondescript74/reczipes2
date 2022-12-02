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
        case df = "Dairy Free?"
    }
    
    @State fileprivate var recName: String = ""
    @State fileprivate var aggLikes: Int = 0
    @State fileprivate var cheap: Bool = true
    @State fileprivate var cookmin: Int = 0
    @State fileprivate var creds: String = ""
    @State fileprivate var xection: Int = 0
    @State fileprivate var dairyF: Bool = false
    
    // MARK: - Methods
    fileprivate func saveIt() -> Bool {
        return false
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField(msgs.en.rawValue, text: $recName)
                    Picker(msgs.al.rawValue, selection: $aggLikes) {
                        ForEach(0 ..< 100) {
                            Text("\($0) likes")
                        }
                    }
                    HStack {
                        Text(msgs.chp.rawValue)
                        Button("Change", action:{cheap.toggle()}).buttonStyle(.bordered)
                    }
                    
                    Picker(msgs.cm.rawValue, selection: $cookmin) {
                        ForEach(0 ..< 300) {
                            Text("\($0) minutes")
                        }
                    }
                    TextField(msgs.cred.rawValue, text: $creds)
                    Picker(msgs.cuis.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(0..<zx, id: \.self) { index in
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
