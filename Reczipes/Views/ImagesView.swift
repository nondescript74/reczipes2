//
//  ImagesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct ImagesView: View {
    // MARK: Debug local
    private var zBug: Bool = false
    // MARK: - Environment
    @EnvironmentObject var aui: AllUserImages
    // MARK: - Initializer
    init(recipeuuid: UUID) {
        self.myRecipeUUID = recipeuuid
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID
    fileprivate var myImages:[ImageSaved] = []
    fileprivate enum msgs: String {
        case iv = "ImagesView: "
        case cantdecodeimage = "Can't decode image from data"
        case numberofimages = "Number of images for recipe "
        case up = "No rotation needed"
        case left = "Image is left"
        case right = "Image is right"
        case down = "Image is down"
        case other = "Not LRUDown"
        case rimages = "RecipeImages"
//        case recz = "Reczipes"
        case fau = "Found an Image"
        case rshippd = "recipesShipped"
    }

    // MARK: - Methods
    fileprivate func getUIImageFromData(data: Data) -> UIImage {
        let myReturn: UIImage = UIImage()
        guard let zImg = UIImage(data: data) else { return myReturn }
        return zImg
        
    }
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(aui.images.filter({$0.recipeuuid == myRecipeUUID}), id: \.self) { savedImage in
                        Image(uiImage: getUIImageFromData(data: savedImage.imageSaved))
                    }
                }
            }
        }
    }
}


struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(recipeuuid: UUID(uuidString: "9926BA12-55C3-4B26-800B-B68AA8D80474")!)
            .environmentObject(AllUserImages())
    }
}

