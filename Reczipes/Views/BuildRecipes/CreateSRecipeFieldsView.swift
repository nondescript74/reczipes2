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
        case al = "Aggregate likes"
        case chp = "Cheap?"
    }

    @State fileprivate var aggLikes: Int = 0
    @State fileprivate var cheap: Bool = true
    var body: some View {
        NavigationView {
            Form {
                Picker(msgs.al.rawValue, selection: $aggLikes) {
                    ForEach(0 ..< 100) {
                        Text("\($0) likes")
                    }
                }
                HStack {
                    Text(msgs.chp.rawValue)
                    Button("True", action:{cheap.toggle()}).buttonStyle(.bordered)
                    switch cheap {
                    case true:
                        Text("True").padding(.leading)
                    default:
                        Text("False").padding(.leading)
                    }
                }
            }
        }
    }
}

struct CreateSRecipeFieldsView_Previews: PreviewProvider {
    static let rbb = RecipeBeingBuilt()
    @State fileprivate var aLikes: String?
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
