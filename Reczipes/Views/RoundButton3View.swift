//
//  RoundButton3View.swift
//  RoundButton3View
//
//  Created by Zahirudeen Premji on 8/21/21.
//

import SwiftUI

struct RoundButton3View: View {
    
    // MARK: - Properties
    var someTextTop: String
    var someTextBottom: String
    var someImage: String
    var colorFrame: Color = Color.black
    var reversed: Bool = false
    
    // MARK: - View Process
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: someImage)
                    .font(.title)
                
                Circle()
                    .strokeBorder(colorBackgroundButton, lineWidth: 2)
                    .frame(width: 45, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Circle()
                    .fill(colorForegroundButton)
                    .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            Text(someTextTop)
                .foregroundColor(.blue)
                .font(.system(size: 10, weight: .light, design: .serif))
            Text(someTextBottom)
                .foregroundColor(.blue)
                .font(.system(size: 10, weight: .light, design: .serif))
        }
    }
}

struct RoundButton3View_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton3View(someTextTop: "Add", someTextBottom: "Image", someImage: "plus", reversed: true)}
}
