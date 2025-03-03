//
//  AllRecipesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/9/21.
//

import SwiftUI
import os

struct AllRecipesView: View {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.Recipes", category: "AllRecipesView")
    // MARK: - Environment Objects
    @Environment(AllUserRecipes.self) private var aur
    // MARK: - Methods
    var myBook: [BookSection] {
        return aur.sections.sorted(by: {$0.name < $1.name})
    }
    // MARK: - View Process
    var body: some View {
        NavigationView {
            VStack {
                Text("All Recipes").font(.largeTitle).bold()
                
                List {
                    ForEach(myBook, id: \.self) { section in
                        Section(header: Text(section.name)
                            .padding()
                            .fontWeight(.bold))
                        {
                            ForEach(section.items) { item in
                                RecipeRowView(sectionItem: item, cuisine: section.name)
                                    .padding()
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
        }
        .environment(aur)
    }
}


struct AllRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AllRecipesView()
                .environment(AllUserRecipes())
        }
    }
}
