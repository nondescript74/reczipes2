//
//  LoadableImageView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/8/25.
//

import SwiftUI

struct LoadableImageView: View {
    var imageMetadata: SectionItem3
    
    var body: some View {
        AsyncImage(url: URL(string: (imageMetadata.imageUrl ?? SectionItem3.example.imageUrl)!)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .accessibility(hidden: false)
                    .accessibilityLabel(Text(imageMetadata.name))
//            }  else if phase.error != nil  {
//                VStack {
//                    Image("IMG_Rae_312x312")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: 300)
//                    Text("The recipes were all busy.")
//                        .font(.title2)
//                    Text("Please try again.")
//                        .font(.title3)
//                }
                
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoadableImageView(imageMetadata: SectionItem3.example2)
}
