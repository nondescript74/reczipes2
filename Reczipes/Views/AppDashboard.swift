//
//  AppDashboard.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 2/14/25.
//

import SwiftUI

struct AppDashboard: View {
    
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var ratio: RecipeRatio
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var aui: AllUserImages
    
    let columnLayout = Array(repeating: GridItem(.flexible()), count: 3)
    
    fileprivate enum tabs: String {
        case recipes = "Recipes"
        case uf = "User Files"
        case frextr = "Find or Get"
        case ingredients = "Ingredients"
        case jt = "Joke/Trivia"
        case prof = "Profile"
        case settings = "Settings"
        case enterKey = "ApiKey"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columnLayout) {
                    VStack {
                        NavigationLink(destination: AllRecipesView()) {
                            Image(systemName: "fork.knife.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.recipes.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: FindOrExtractView()) {
                            Image(systemName: "pencil.tip.crop.circle.badge.plus")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.frextr.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: OrderIngredientsView2()) {
                            Image(systemName: "heart.text.clipboard")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.ingredients.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: KeyView()) {
                            Image(systemName: "entry.lever.keypad.trianglebadge.exclamationmark")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.enterKey.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear.badge")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.settings.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: FilesDisplayView2()) {
                            Image(systemName: "folder.fill.badge.plus")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.uf.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: MultiView()) {
                            Image(systemName: "newspaper")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.jt.rawValue)
                    }
                    VStack {
                        NavigationLink(destination: ProfileEditor(profile: $userData.profile)) {
                            Image(systemName: "person.fill")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.prof.rawValue)
                    }
                }
            }
            .navigationTitle("Dashboard")
            .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .environmentObject(order)
        .environmentObject(userData)
        .environmentObject(ratio)
        .environmentObject(aun)
        .environmentObject(aui)
        .environmentObject(aur)
        
    }
}

#Preview {
    AppDashboard()
        .environmentObject(OrderingList())
        .environmentObject(UserData())
        .environmentObject(RecipeRatio())
        .environmentObject(AllUserRecipes())
        .environmentObject(AllUserNotes())
        .environmentObject(AllUserImages())
}
