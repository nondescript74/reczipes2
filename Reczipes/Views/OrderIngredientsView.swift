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
    @EnvironmentObject var ratio: RecipeRatio
    // MARK: - State
    // MARK: - ObservedObject
    // MARK: - Properties
    fileprivate enum msgs: String {
        case orderIngredientsView, OIV = "OrderIngredientsView: "
    }
    
    fileprivate enum labelz: String {
        case half = "Half"
        case double = "Double"
        case tq = "3/4"
        case fq = "5/4"
        case rec = "Recipe"
        
    }
    
    fileprivate enum imagez: String {
        case double = "square.and.pencil"
        case half = "pencil"
        case tq = "greetingcard"
        case fq = "envelope"
        
    }

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
                
                HStack {
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 2.0)
                        
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.double.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.double.rawValue, reversed: false)
                    }  // .disabled(order.items.count == 1)
                    
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 0.5)
                        
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.half.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.half.rawValue, reversed: false)
                    }   //.disabled(order.items.count == 1)
                    
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 0.75)
                        
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.tq.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.tq.rawValue, reversed: false)
                    }   //.disabled(order.items.count == 1)
                    
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 1.25)
                        
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.fq.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.fq.rawValue, reversed: false)
                    }   //.disabled(order.items.count == 1)
                    
                }
                
                ForEach(order.items, id: \.self) { item in
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
//struct OrderIngredientsView_Previews: PreviewProvider {
//    // MARK: Properties
//    static let order: () = OrderingList().add(item: SectionItem.example)
//    static let userData = UserData()
//    static var previews: some View {
//        OrderIngredientsView(ratio: 1.0))
//            .previewDevice("iPhone Xr")
//
//    }
//}

