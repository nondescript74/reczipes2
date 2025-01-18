//
//  OrderIngredientsView2.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/2/23.
//

import SwiftUI

struct OrderIngredientsView2: View {
    // MARK: - Environment Variables
    @EnvironmentObject var order: OrderingList
    @EnvironmentObject var ratio: RecipeRatio
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case orderIngredientsView2, OIV2 = "OrderIngredientsView2: "
    }
    
    fileprivate enum labelz: String {
        case half = "Half"
        case double = "Double"
        case tq = "3/4"
        case fq = "5/4"
        case full = "Full"
        case rec = "Recipe"
        case ingredients = "Ingred"
        case remove = "Remove"
        case trash = "trash"
        
    }
    
    fileprivate enum imagez: String {
        case double = "square.and.pencil"
        case half = "pencil"
        case tq = "greetingcard"
        case fq = "envelope"
        case full = "cross.circle.fill"
    }
    
    // MARK: - View Process
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(order.items, id: \.self) {item in
                    HStack {
                        Text(item.name).font(.headline)
                        Button(action: {
                            // What to perform
                            self.order.remove(item: item)
                        }) {
                            // How the button looks like
                            RoundButton3View(someTextTop: labelz.remove.rawValue, someTextBottom: labelz.ingredients.rawValue, someImage: labelz.trash.rawValue, reversed: false)
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 1.0)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.full.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.full.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 2.0)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.double.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.double.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 0.5)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.half.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.half.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 0.75)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.tq.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.tq.rawValue, reversed: false)
                    }
                    Button(action: {
                        // What to perform
                        ratio.change(amount: 1.25)
                    }) {
                        // How the button looks like
                        RoundButton3View(someTextTop: labelz.fq.rawValue, someTextBottom: labelz.rec.rawValue, someImage: imagez.fq.rawValue, reversed: false)
                    }
                    
                }.padding(.bottom)
                
                VStack {
                    ForEach(order.items, id: \.self) { item in
                        VStack {
                            Text(item.name)
                            ExtendendIngredientsView2(sectionitem: item)
                        }
                    }
                }
            }
            .navigationTitle("Ingredient Ordering")
        }
        .environmentObject(ratio)
        .environmentObject(order)
    }
    
}

struct OrderIngredientsView2_Previews: PreviewProvider {
    static let ratio = RecipeRatio()
    static let order = OrderingList()
    static var previews: some View {
        OrderIngredientsView2()
            .environmentObject(order)
            .environmentObject(ratio)
    }
}
