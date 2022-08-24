//
//  OrderIngredientsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 11/25/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct OrderIngredientsView: View {
    // MARK: - Initializer
    // MARK: - Environment Variables
    @EnvironmentObject var order: OrderingList
    // MARK: - ObservedObject
    // MARK: - Properties
    // MARK: - Methods
    // MARK: - View Process
    var body: some View {
        NavigationView {
            VStack {
                Section(header: ListHeader(myText: "Recipes To Order For")) {
                    ForEach(order.items, id: \.self) {item in
                        RecipeRowView(sectionItem: item)
                    }
                }
                
                ForEach(order.items, id: \.self) {item in
                    ExtendendIngredientsView2(sectionitem: item)
                }
                
            }
            .navigationBarTitle("Ingredient Ordering")
        }
    }
}


struct ListHeader: View {
    var myText: String
    var body: some View {
        HStack {
            //Image(systemName: "map")
            Text(myText).foregroundColor(.red)
        }
    }
}


// MARK: - Previews
struct OrderIngredientsView_Previews: PreviewProvider {
    // MARK: Properties
    static let order: () = OrderingList().add(item: SectionItem.example)
    static let userData = UserData()
    static var previews: some View {
        OrderIngredientsView()
            .previewDevice("iPhone Xr")
        
    }
}

