//
//  NutritionRowView.swift
//  CRecipes
//
//  Created by Zahirudeen Premji on 12/10/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct NutritionRowView: View {
    // MARK: - Initializer
    init(valueName: String, minVal: Int, maxVal: Int) {
        self.myValueName = valueName
        self.myMinVal = minVal
        self.myMaxVal = maxVal
    }
    // MARK: - Properties
    fileprivate var myValueName: String
    fileprivate var myMinVal: Int
    fileprivate var myMaxVal: Int
    // MARK: - View Process
    var body: some View {
        HStack(alignment: .top) {
            Text(myValueName + " : ")
                .foregroundColor(.purple)
                .fontWeight(.bold)
                .frame(width: 125, height: 20, alignment: .leading)
                .padding()
                
            HStack {
                Text(" min ")
                Text(myMinVal.description)
                    .bold()
                    .font(.body)
                    .foregroundColor(.orange)
            }
            .frame(width: 70, height: 20, alignment: .leading)
            .padding()
            HStack {
                Text("max ")
                Text(myMaxVal.description)
                    .bold()
                    .font(.body)
                    .foregroundColor(.red)
            }
            .frame(width: 100, height: 20, alignment: .leading)
            .padding()
        }
        
    }
}

struct NutritionRowView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionRowView(valueName: "Marijuana", minVal: 10, maxVal: 125)
    }
}
