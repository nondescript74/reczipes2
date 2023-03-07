//
//  Profile.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation

struct Profile {
    var username: String
    var id: String
    var email: String
    var prefersNotifications: Bool
    var prefersNutritionInclusion: Bool
    var prefersVitaminInclusion: Bool
    var seasonalPhoto: Season
    var numberOfRecipes: NumberZ

    static let `default` = Self(username: "Guest", id: "Sample ID", email: "somebody@gmail.com", prefersNotifications: true, prefersNutrition: false, prefersVitamins: false, seasonalPhoto: .summer, numberz: NumberZ.four)
    
    init(username: String, id: String, email:String, prefersNotifications: Bool = true, prefersNutrition: Bool = false, prefersVitamins: Bool = false, seasonalPhoto: Season = .summer, numberz: NumberZ = NumberZ.four, loadnewrecipes: Bool = false) {
        self.username = username
        self.email = email
        self.id = id
        self.prefersNotifications = prefersNotifications
        self.prefersNutritionInclusion = prefersNutrition
        self.prefersVitaminInclusion = prefersVitamins
        self.seasonalPhoto = seasonalPhoto
        self.numberOfRecipes = numberz
        
        
//        UserDefaults.standard.set(self, forKey: "profile")
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
        case spring = "zhome"
        case summer = "zbeach"
        case autumn = "zdesert"
        case winter = "zdiving"
    }
    
    enum NumberZ: Int, CaseIterable {
        case one = 1
        case two = 2
        case four = 4
        case eight = 8
        case sixteen = 16
        case thirtytwo = 32
    }

}
