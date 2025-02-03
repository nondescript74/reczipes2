//
//  RecipeRowView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct RecipeRowView: View {

    // MARK: - Initializer
    init(sectionItem: SectionItem3) {
        self.item = sectionItem
        self.cuisine = ""
    }
    
    init(sectionItem: SectionItem3, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
    }
    
    // MARK: - Properties
    fileprivate var item: SectionItem3
    fileprivate var cuisine: String = ""


    // MARK: - View Process
    var body: some View {
        NavigationLink(destination: RecipeDetailView(sectionItem: item)) {
            VStack(alignment: .leading) {
                ZStack  {
                    AsyncImage(url: URL(string: (item.imageUrl ?? SectionItem3.example.imageUrl)!)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .accessibility(hidden: false)
                                .accessibilityLabel(Text(item.name))
                        } else {
                            ProgressView()
                        }
                        Text(item.photocredit).font(.caption).foregroundColor(.gray)
                    }
                }
                HStack {
                    ForEach(item.restrictions, id: \.self) { restriction in
                        Text(restriction)
                            .font(.caption)
                            .padding(paddingSize)
                            .clipShape(Rectangle())
                    }
                }
                Text(item.name).padding(.trailing)
            }
        }
    }
}


struct RecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecipeRowView(sectionItem: SectionItem3.example, cuisine: "Indian")
        }
    }
}


