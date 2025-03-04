//
//  ImagesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct ImagesView: View {
    // MARK: - Environment
    @Environment(AllUserImages.self) private var aui
    
    // MARK: - Initializer
    init(recipeuuid: UUID) {
        self.myRecipeUUID = recipeuuid
        #if DEBUG
        print("ImagesView initialized")
        print(self.myRecipeUUID.description)
        #endif
    }
    
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID


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
            .environment(aui)
        }
        
    }
}


struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(recipeuuid: UUID(uuidString: "E28071B5-8385-456A-BD04-1CE169FF3A71")!)
            .environment(AllUserImages())
    }
}

