//
//  RoundButton2View.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct RoundButton2View: View {
    // MARK: - State
    // MARK: - Properties
    var someTextTop: String
    var someTextBottom: String
    var someImage: String
    var colorFrame: Color = Color.black
    var reversed: Bool = false
    // MARK: - View Process
    var body: some View {
        if reversed {
            HStack {
                ZStack {
                    Image(systemName: someImage)
                        .font(.title)
                    
                    Circle()
                        .strokeBorder(colorBackgroundButton, lineWidth: 4)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Circle()
                        .fill(colorForegroundButton)
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                
                VStack {
                    Text(someTextTop)
                        .foregroundColor(.blue)
                        .font(.system(size: 10, weight: .light, design: .serif))
                    Text(someTextBottom)
                        .foregroundColor(.blue)
                        .font(.system(size: 10, weight: .light, design: .serif))
                }
            }
            
        } else {
            
            HStack {
                
                VStack {
                    Text(someTextTop)
                        .foregroundColor(.blue)
                        .font(.system(size: 10, weight: .light, design: .serif))
                    Text(someTextBottom)
                        .foregroundColor(.blue)
                        .font(.system(size: 10, weight: .light, design: .serif))
                }
                
                ZStack {
                    Image(systemName: someImage)
                        .font(.title)
                    
                    Circle()
                        .strokeBorder(colorBackgroundButton, lineWidth: 4)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Circle()
                        .fill(colorForegroundButton)
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
        
    }
}

struct RoundButton2View_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton2View(someTextTop: "Add", someTextBottom: "Image", someImage: "plus", reversed: true)
    }
}



