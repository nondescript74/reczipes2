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

            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoadableImageView(imageMetadata: SectionItem3.example2)
}
