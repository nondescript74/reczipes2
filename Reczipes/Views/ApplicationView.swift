//
//  ApplicationView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI
import AuthenticationServices

struct ApplicationView: View {
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var ratio: RecipeRatio
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var aui: AllUserImages
    
    // MARK: - Properties
    fileprivate enum tabs: String {
        case recipes = "Recipes"
        case books = "Books"
        case uf = "User Files"
        case frextr = "Find/Extract"
        case auth = "Sign In"
        case ingredients = "Ingred"
        case multiAdd = "+Note/Image"
        case note = "+Note"
        case img = "+Image"
        case jt = "Joke/Trivia"
        case prof = "Profile"
        case settings = "Settings"
        case build = "Build"
        case enterKey = "ApiKey"
        case fi = "find 🍒"
        case load = "Load"
    }
    
    var body: some View {
        NavigationStack {
            Grid {
                GridRow {
                    VStack {
                        NavigationLink(destination: AllRecipesView()) {
                            Image(uiImage: imageDocDocEmpty!)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.recipes.rawValue)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: FindOrExtractView()) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.frextr.rawValue)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: OrderIngredientsView2()) {
                            Image(uiImage: squareandarrowdown!)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.ingredients.rawValue)
                            .foregroundColor(.blue)
                    }
                }.padding(.all, 10)
                
                GridRow {
                    VStack {
                        NavigationLink(destination: KeyView()) {
                            Image(uiImage: checkmarkImage)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.enterKey.rawValue)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: SettingsView()) {
                            Image(uiImage: suitImage)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.settings.rawValue)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: FilesDisplayView2()) {
                            Image(uiImage: lassoImage)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.uf.rawValue)
                            .foregroundColor(.blue)
                    }
                }.padding(.all, 10)
                
                GridRow {
                    VStack {
                        NavigationLink(destination: MultiView()) {
                            Image(uiImage: hare!)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.jt.rawValue)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: ProfileEditor(profile: $userData.profile)) {
                            Image(uiImage: tortoise!)
                                .foregroundColor(.blue)
                                .frame(minHeight: 50)
                        }
                        .padding(.horizontal)
                        .overlay(Capsule().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.prof.rawValue)
                            .foregroundColor(.blue)
                    }
                    
                }.padding(.all, 10)
            }.padding(.all, 30)
        }
        .environmentObject(order)
        .environmentObject(userData)
        .environmentObject(ratio)
        .environmentObject(aun)
        .environmentObject(aui)
        .environmentObject(aur)
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static let order = OrderingList()
    static let userData = UserData()
    static let rratio = RecipeRatio()
    static let aur = AllUserRecipes()
    static let aun = AllUserNotes()
    static let aui = AllUserImages()
    
    static var previews: some View {
        ApplicationView()
            .environmentObject(order)
            .environmentObject(userData)
            .environmentObject(rratio)
            .environmentObject(aur)
            .environmentObject(aun)
            .environmentObject(aui)
    }
}
