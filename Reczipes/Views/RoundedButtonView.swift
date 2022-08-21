//
//  RoundedButtonView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 5/15/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

//struct RoundedButtonView: View {
//    
//    // MARK: - Properties
//    var someText: String
//    var someImage: Image
//    var colorFrame: Color = Color.black
//    var colorBackground: Color = Color.init("ED7D3A")
//    
//    // MARK: - View Process
//    var body: some View {
//        ZStack {
//            someImage
//                .padding(2)
//            Text(someText)
//                .foregroundColor(.blue)
//                .background(Color.white)
//                .rotationEffect(Angle(degrees: 0))
//                .font(Font.system(size: 10, weight: .bold, design: .rounded))
//        }
//        //.clipShape(Circle())
//        .overlay(RoundedRectangle(cornerSize: CGSize(width: 3, height: 3)).stroke(Color.gray, lineWidth: 2))
//    }
//}

struct RoundedButtonView2: View {
    
    // MARK: - Properties
    var someText: String
    var someImage: Image
    var colorFrame: Color = Color.black
    var colorBackground: Color = Color.init("ED7D3A")
    
    // MARK: - View Process
    var body: some View {
        VStack {
            someImage
                .padding(2)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            Text(someText)
                .foregroundColor(.blue)
                .background(Color.white)
                .font(Font.system(size: 10, weight: .bold, design: .rounded))
                
        }
        //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
    }
}

#if DEBUG
// MARK: - Previews
struct RoundedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonView2(someText: "Z", someImage: Image("Z raewen-thumb").renderingMode(.original))
    }
}
#endif
