//
//  AddIngredientView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/24/22.
//

import SwiftUI

struct AddIngredientView: View {
    // MARK: - Local Debug
    fileprivate var zBug: Bool = true
    // MARK: - Environment Variables
    @EnvironmentObject var ingredients: RecipeIngredients
    // MARK: - State
    @State private var searchText = ""
    // MARK: - Properties
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
        ingredients.add(item: toAdd)
#if DEBUG
        if zBug {print(toAdd.name + " " + toAdd.id.description)}
#endif
    }
    
    var body: some View {
        NavigationView {
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
                .navigationTitle("Ingredients")
            }
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names().filter({!$0.isEmpty})
        } else {
            return names().filter {$0.contains(searchText.lowercased())}
        }
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static let recipIngreds = RecipeIngredients()
    static var previews: some View {
        AddIngredientView()
            .environmentObject(recipIngreds)
    }
}

