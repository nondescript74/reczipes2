//
//  BuildRowView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/6/22.
//

import SwiftUI

struct BuildRowView: View {
    // MARK: - Initializer
    init(mori: String) {
        self.units = mori // should be metric or imperial
    }
    // MARK: - State
    @State fileprivate var unitselection: String = ""
    @State fileprivate var valueselection: String = ""
    @State fileprivate var textselection: String = ""
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case brv = "Insert an ingredient"
        case su = "Unit"
        case sv = "Qty"
    }
    fileprivate var units: String = ""
    // MARK: - Methods
    fileprivate func enterMy() {
        let measure = Measure(amount: formatStringDoubleToNumber(stringToFormat: valueselection), unitShort: unitselection, unitLong: unitselection)
        var ingredient = ExtendedIngredient()
        ingredient.name = textselection
        ingredient.unit = unitselection
        ingredient.image = "someimage"
        ingredient.measures = Measures(us: measure, metric: measure)
    }
    
    fileprivate func getUnits() -> [String] {
        switch self.units {
        case "metric":
             return getUnitsMetric()
        case "imperial":
            return getUnitsImperial()
        default:
            // imperial
            return getUnitsImperial()
        }
    }
    
    fileprivate func getMyValues() -> [String] {
        switch self.units {
        case "metric":
             return getValues(unit: "metric")
        case "imperial":
            return getValues(unit: "imperial")
        default:
            // imperial
            return getValues(unit: "imperial")
        }
    }
    var body: some View {
        VStack {
            Text("Enter and Ingredient and amount")
            
            VStack(alignment: .leading) {
                HStack {
                    Picker(msgs.su.rawValue, selection: $unitselection) { let zx = getUnits().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getUnits()[index])")
                        }
                    }
                    
                    Picker(msgs.sv.rawValue, selection: $valueselection) { let zx = getMyValues().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getMyValues()[index])")
                        }
                    }
                    TextField("Enter Ingredient name", text: $textselection).foregroundColor(.blue)
                    Button("Add", action: enterMy)
                }
            }
        }
    }
}

struct BuildRowView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRowView(mori: "imperial")
    }
}
