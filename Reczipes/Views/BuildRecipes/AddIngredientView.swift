//
//  AddIngredientView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/24/22.
//

import SwiftUI

struct AddIngredientView: View {
    @State private var searchText = ""
    let names = {
        let myList = getIngredList()
        var myReturnList = [""]
        for anIngred in myList {
            myReturnList.append(anIngred.name ?? "No Ingred Name????")
        }
        return myReturnList.sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink(destination: Text(name)) {
                        Text(name)
                    }
                }
            }
            .searchable(text: $searchText) {
                ForEach(searchResults, id: \.self) { result in
                    Text("Are you looking for \(result)?").searchCompletion(result)
                }
            }
            .navigationTitle("Ingredients")
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names()
        } else {
            return names().filter { $0.contains(searchText) }
        }
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}

