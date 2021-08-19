//
//  RecipeRowView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct RecipeRowView: View {
    // MARK: - Environment
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Initializer
    init(sectionItem: SectionItem) {
        self.item = sectionItem
        // check for empty
        if item.imageUrl == nil {
            
            #if DEBUG
            print("RecipeRowView: sectionItem.imageUrl is nil, using thumbnail in app")
            #endif
            
        } else {
            
            #if DEBUG
            print("RecipeRowView: sectionItem.imageUrl available, going to get")
            #endif
            
            anImage.getImageFromUrl(urlString: item.imageUrl!, type: WebQueryRecipes.callerId.fullurlbeingsupplied)
        }
    }
    
    // MARK: - Properties
    fileprivate var item: SectionItem
    //var addedView: Bool = false
    
    // MARK: - Methods
//    fileprivate func getImageToSend() -> Image {
//        if addedView {
//            return anImage.anImage ?? Image("Default Image")
//        } else {
//            return Image(item.mainImage)
//        }
//    }
    
    
    // MARK: - View Process
    var body: some View {
        NavigationLink(destination: RecipeDetailView(imageString: (item.imageUrl ?? defaultImageUrl)!, sectionItem: item)) {
//            if addedView {
                VStack(alignment: .leading) {
                HStack {
                    anImage.anImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .leading)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    
                    VStack {
                        Text(item.name)
                            .font(.system(size: 13))
                    }
                }
                HStack {
                    ForEach(item.restrictions, id: \.self) { restriction in
                        Text(restriction)
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(10)
                            .background(colors[restriction, default: .black]) .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }
                }
                
//            } else {
//                VStack(alignment: .leading) {
//                    HStack {
//                        Image(item.thumbnailImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40, alignment: .leading)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//
//                        VStack {
//                            Text(item.name)
//                                .font(.system(size: 13))
//                        }
//                    }
//                    HStack(alignment: .top) {
//                        ForEach(item.restrictions, id: \.self) { restriction in
//                            Text(restriction)
//                                .font(.caption)
//                                .fontWeight(.black)
//                                .padding(10)
//                                .background(colors[restriction, default: .black]) .clipShape(Circle())
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            }
        }
    }
}

#if DEBUG
struct RecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecipeRowView(sectionItem: SectionItem.example)
            RecipeRowView(sectionItem: SectionItem.example2)
        }.previewDevice("iPhone Xr")
        
    }
}
#endif

