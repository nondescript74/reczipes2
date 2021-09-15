//
//  PlusSignAndRecipeRowView.swift
//  PlusSignAndRecipeRowView
//
//  Created by Zahirudeen Premji on 8/17/21.
//

import SwiftUI

struct PlusSignAndRecipeRowView: View {
    
    // MARK: - Environment
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Properties
    fileprivate var item: SectionItem
    // MARK: - Initializer
    init(sectionItem: SectionItem) {
        self.item = sectionItem
        
#if DEBUG
        print("RecipeRowView: sectionItem.imageUrl available, going to get")
#endif
        
        anImage.getImageFromUrl(urlString: item.imageUrl!, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        
    }
    var body: some View {
        HStack {
            //PlusSignView(sectionItem: self.item)
            RecipeRowView(sectionItem: self.item)
        }
    }
}

struct PlusSignAndRecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlusSignAndRecipeRowView(sectionItem: SectionItem.example2)
    }
}
