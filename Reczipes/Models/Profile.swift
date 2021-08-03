//
//  Profile.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications: Bool
    var prefersNutritionInclusion: Bool
    var prefersVitaminInclusion: Bool
    var seasonalPhoto: Season
    var spoonacularApiKey: String
    var numberOfRecipes: NumberZ
    var nutrition: Nutrition
    var vitamins: Vitamins
    var loadNewRecipes: Bool

    static let `default` = Self(username: "carol.premji@yahoo.com", prefersNotifications: true, prefersNutrition: false, prefersVitamins: false, seasonalPhoto: .summer, numberz: NumberZ.four, nutrition: Nutrition.default, vitamins: Vitamins.default, loadnewrecipes: false)
    
    init(username: String, prefersNotifications: Bool = true, prefersNutrition: Bool = false, prefersVitamins: Bool = false, seasonalPhoto: Season = .summer, numberz: NumberZ = NumberZ.four, nutrition: Nutrition, vitamins: Vitamins, loadnewrecipes: Bool = false) {
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.prefersNutritionInclusion = prefersNutrition
        self.prefersVitaminInclusion = prefersVitamins
        self.seasonalPhoto = seasonalPhoto
        self.spoonacularApiKey = apiKeyE.carol.rawValue
        self.numberOfRecipes = numberz
        self.nutrition = nutrition
        self.vitamins = vitamins
        self.loadNewRecipes = loadnewrecipes
    }
    
    struct RestOf {
        var number: Int = 10
        var offset: Int = 0
        var random: Bool = true
        var limitLicense: Bool = true
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(number)
            hasher.combine(offset)
            hasher.combine(limitLicense)
            hasher.combine(random)
        }
    }
    
    enum Season: String, CaseIterable {
        case spring = "carolhome"
        case summer = "carolbeach"
        case autumn = "caroldesert"
        case winter = "caroldiving"
    }
    
    enum NumberZ: Int, CaseIterable {
        case one = 1
        case two = 2
        case four = 4
        case eight = 8
        case sixteen = 16
        case thirtytwo = 32
    }
    
    enum apiKeyE: String {
        case z = "&apiKey=27d2d9f90a8d4bf48e69ad6b819d7c1c"
        case carol = "&apiKey=e4f5bc5bd30946fd8de219c5b0e7e665"
    }
}
