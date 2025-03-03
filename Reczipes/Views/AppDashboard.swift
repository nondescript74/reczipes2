//
//  AppDashboard.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 2/14/25.
//

import SwiftUI

struct AppDashboard: View {
    
    // MARK: - Environment Variables
    @State private var userData:UserData = UserData()
    @State private var order: OrderingList = OrderingList()
    @State private var ratio: RecipeRatio = RecipeRatio()
    @State private var aur: AllUserRecipes = AllUserRecipes()
    @State private var aun: AllUserNotes = AllUserNotes()
    @State private var aui: AllUserImages = AllUserImages()
    
    @State private var selectedView: (any View)? = AllRecipesView()
    
    let columnLayout = Array(repeating: GridItem(.flexible()), count: 3)
    
    let allColors: [Color] = [Color.pink, Color.blue, Color.red, Color.green, Color.yellow, Color.purple, Color.orange, Color.mint, Color.gray, Color.teal, Color.cyan, Color.brown, Color.indigo]

    
    fileprivate enum tabs: String {
        case recipes = "Recipes"
        case uf = "User Files"
        case frextr = "Find or Get"
        case ingredients = "Ingredients"
        case jt = "Joke/Trivia"
        case prof = "Profile"
        case gppg = "Google"
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
                    VStack {
                        NavigationLink(destination: GoogleSearchView()) {
                            Image(systemName: "person.fill")
                                .symbolRenderingMode(.multicolor)
                                .frame(minHeight: 100)
                        }
                        .padding(.horizontal)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.horizontal)
                        Text(tabs.gppg.rawValue)
                    }
                }
            }
            .navigationTitle("Dashboard")
            .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .environment(order)
        .environment(userData)
        .environment(ratio)
        .environment(aun)
        .environment(aui)
        .environment(aur)
        
    }
}

#Preview {
    AppDashboard()
        .environment(OrderingList())
        .environment(UserData())
        .environment(RecipeRatio())
        .environment(AllUserRecipes())
        .environment(AllUserNotes())
        .environment(AllUserImages())
}
