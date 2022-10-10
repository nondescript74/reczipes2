//
//  InsertIngredientView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/5/22.
//

import SwiftUI

struct InsertIngredientView: View {
    // MARK: - State
    @State fileprivate var unitselection: String = ""
    @State fileprivate var valueselection: String = ""
    @State fileprivate var textselection: String = ""
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case iiv = "Insert an ingredient"
        case su = "Select a unit"
        case sv = "Select amount"
    }
    // MARK: - Methods
    fileprivate func enterMy() {
        let measure = Measure(amount: formatStringDoubleToNumber(stringToFormat: valueselection), unitShort: unitselection, unitLong: unitselection)
        var ingredient = ExtendedIngredient()
        ingredient.name = textselection
        ingredient.unit = unitselection
        ingredient.image = "someimage"
        ingredient.measures = Measures(us: measure, metric: measure)
        
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Enter and Ingredient and amount")
                
                    VStack(alignment: .leading) {
                        HStack {
                            Picker(msgs.su.rawValue, selection: $unitselection) { let zx = getUnitsMetric().count
                                ForEach(0..<zx, id: \.self) { index in
                                    Text("\(getUnitsMetric()[index])")
                                }
                            }
                            
                            Picker(msgs.sv.rawValue, selection: $valueselection) { let zx = getValues(unit: "metric").count
                                ForEach(0..<zx, id: \.self) { index in
                                    Text("\(getValues(unit: "metric")[index])")
                                }
                            }
                            TextField("Enter Ingredient name", text: $textselection).foregroundColor(.blue)
                            Button("Add", action: enterMy)
                        }
                    }
                
                Text("Or")
                
                    VStack(alignment: .leading) {
                        HStack {
                            Picker(msgs.su.rawValue, selection: $unitselection) { let zx = getUnitsImperial().count
                                ForEach(0..<zx, id: \.self) { index in
                                    Text("\(getUnitsImperial()[index])")
                                }
                            }
                            
                            Picker(msgs.sv.rawValue, selection: $valueselection) { let zx = getValues(unit: "imperial").count
                                ForEach(0..<zx, id: \.self) { index in
                                    Text("\(getValues(unit: "imperial")[index])")
                                }
                            }
                            
                            TextField("Enter Ingredient name", text: $textselection).foregroundColor(.blue)
                            Button("Add", action: enterMy)
                        }
                        
                    }
                    
                }
                
            }
        }
    
}

struct InsertIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        InsertIngredientView()
    }
}
