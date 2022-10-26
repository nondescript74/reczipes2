//
//  InsertIngredientView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/5/22.
//

import SwiftUI

struct InsertIngredientView: View {
    // MARK: - Local Debug
    fileprivate var zBug: Bool = true
    // MARK: - State
    @State fileprivate var unitselection: String = ""
    @State fileprivate var valueselection: String = ""
    @State fileprivate var textselection: String = ""
    // MARK: - State
    @State fileprivate var searchText = ""
    @State fileprivate var ingredients: [Ingredient] = []
    // MARK: - Properties
    fileprivate enum msgs: String {
        case iiv = "Insert an ingredient"
        case su = "Select a unit"
        case sv = "Select amount"
    }
    let names = {
        let myList = getIngredList()
        var myReturnList = [""]
        for anIngred in myList {
            myReturnList.append(anIngred.name )
        }
        return myReturnList.sorted()
    }
    // MARK: - Methods
    fileprivate func addIngred(name: String) {
        var myList = getIngredList()
        myList = myList.filter({$0.name == name})
        let myFirst = myList.first
        if myFirst == nil {
#if DEBUG
            if zBug {print(name + " " + "does not exist")}
            return
#endif
        }
        let toAdd = getIngredientForName(name: myFirst!.name)
        ingredients.append(toAdd)
#if DEBUG
        if zBug {print(toAdd.name + " " + toAdd.id.description)}
#endif
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
    var searchResults: [String] {
        if searchText.isEmpty {
            return names().filter({!$0.isEmpty})
        } else {
            return names().filter {$0.contains(searchText.lowercased())}
        }
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
                            
                            VStack {
                                List {
                                    ForEach(searchResults, id: \.self) { name in
                                        Button("Add " + name, action: { addIngred(name: name)})
                                            .buttonStyle(.bordered)
                                    }
                                }
                                .searchable(text: $searchText) {
                                    ForEach(searchResults, id: \.self) { result in
                                        Text("Looking for \(result)?").searchCompletion(result)
                                    }
                                }
                                
                            }
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
            .navigationTitle("Add Ingredients")
            }
        }
}

struct InsertIngredientView_Previews: PreviewProvider {
    static let recipIngr = RecipeIngredients()
    static var previews: some View {
        InsertIngredientView()
            .environmentObject(recipIngr)
    }
}
