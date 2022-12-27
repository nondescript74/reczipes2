//
//  FridgeSummary.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 9/15/22.
//

import SwiftUI

struct FridgeSummary: View {
    @EnvironmentObject var fridge: FridgeContents
    
    var body: some View {
        List {
            ForEach(fridge.myContents.allKeys as! [String], id: \.self) { aKey in
                HStack {
                    Text(aKey)
                    Text("\(fridge.myContents.value(forKey: aKey) as! Double)")
                }.padding()
            }
        }
    }
}

struct FridgeSummary_Previews: PreviewProvider {
    static var fridge = FridgeContents()
    static var previews: some View {
        FridgeSummary()
            .environmentObject(fridge)
    }
}
