//
//  RecipeRowView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct RecipeRowView: View {
    // MARK: - Debug
    private var zBug: Bool = false 
    // MARK: - Environment
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Initializer
    init(sectionItem: SectionItem) {
        self.item = sectionItem
        self.cuisine = ""
        // check for empty
        if item.imageUrl == nil {
#if DEBUG
            if zBug {print("RecipeRowView: sectionItem.imageUrl is nil")}
#endif
        } else {
#if DEBUG
            if zBug {print("RecipeRowView: no cuisine available")}
            if zBug {print("RecipeRowView: sectionItem.imageUrl available, going to get")}
#endif
            anImage.getImageFromUrl(urlString: item.imageUrl!, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        }
    }
    
    init(sectionItem: SectionItem, cuisine: String) {
        self.item = sectionItem
        self.cuisine = cuisine
        // check for empty
        if item.imageUrl == nil {
            
        } else {
            
            anImage.getImageFromUrl(urlString: item.imageUrl!, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        }
    }
    
    // MARK: - Properties
    fileprivate var item: SectionItem
    fileprivate var cuisine: String = ""
    private let widthImage: CGFloat = 100
    private let heightImage: CGFloat = 70
    private let overlayLWidth: CGFloat = 2
    private let paddingSize: CGFloat = 2
    private let lineLimit: Int = 3
    // MARK: - Methods
    // MARK: - View Process
    var body: some View {
        NavigationLink(destination: RecipeDetailView(imageString: (item.imageUrl ?? defaultImageUrl)!, sectionItem: item, cuisine: cuisine)) {
            VStack(alignment: .leading) {
                HStack {
                    anImage.anImage?
                        .resizable()
                        .scaledToFill()
                        .frame(width: widthImage, height: heightImage, alignment: .leading)
                        .clipShape(Rectangle())
                        .overlay(Rectangle().stroke(Color.gray, lineWidth: overlayLWidth))
                    
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
            RecipeRowView(sectionItem: SectionItem.example, cuisine: "Indian")
            RecipeRowView(sectionItem: SectionItem.example2)
        }
    }
}


