//
//  NutritionRowView.swift
//  Reczipes
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
    fileprivate enum msgs: String {
        case sep = " : "
        case min = " min "
        case max = " max "
    }
    // MARK: - View Process
    var body: some View {
        HStack(alignment: .top) {
            Text(myValueName + msgs.sep.rawValue)
//                .foregroundColor(.purple)
//                .frame(width: 125, height: 20, alignment: .leading)
                
//            HStack {
                Text(msgs.min.rawValue)
                Text(myMinVal.description)
//                    .font(.body)
                    .foregroundColor(.orange)
//            }
//            .frame(width: 70, height: 20, alignment: .leading)
//            .padding()
//            HStack {
                Text(msgs.max.rawValue)
                Text(myMaxVal.description)
//                    .font(.body)
                    .foregroundColor(.red)
//            }
//            .frame(width: 100, height: 20, alignment: .leading)
//            .padding()
        }.padding()
        
    }
}

struct NutritionRowView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionRowView(valueName: "Marijuana", minVal: 10, maxVal: 125)
    }
}
