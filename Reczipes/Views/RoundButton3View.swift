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
    var reversed: Bool  // set this to true when the button is not active
    
    // MARK: - View Process
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .strokeBorder(reversed ? Color.gray : Color.black, lineWidth: 2)
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Circle()
                    .fill(reversed ? Color.white : Color.blue)
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            Text(someTextTop)
                .foregroundColor(reversed ? Color.gray : Color.black)
                .font(.system(size: 12, weight: .regular, design: .serif))
            Text(someTextBottom)
                .foregroundColor(reversed ? Color.gray : Color.black)
                .font(.system(size: 12, weight: .regular, design: .serif))
        }
    }
}

struct RoundButton3View_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton3View(someTextTop: "Add", someTextBottom: "yourself", someImage: "plus", reversed: false)
    }
}
