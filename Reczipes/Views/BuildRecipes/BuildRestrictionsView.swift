//
//  BuildRestrictionsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/30/22.
//
import SwiftUI

struct BuildRestrictionsView: View {
    @EnvironmentObject var rbb: RecipeBeingBuilt
    @State var restrictionName: String = "Gluten Free"
    
    fileprivate func getRestrictionNames() -> [String] {
        let restrictions = Bundle.main.decode([Restriction].self, from: "restrictions.json")
        var names: [String] = []
        for restriction in restrictions {
            names.append(restriction.name)
        }
        return names
    }
    
    fileprivate func getDescForName(name: String) -> String {
        var myReturn = "no description found"
        let restrictions = Bundle.main.decode([Restriction].self, from: "restrictions.json")
        guard let idx = restrictions.firstIndex(where: {$0.name == name}) else { return myReturn }
        let theOne = restrictions[idx]
        myReturn = theOne.description
        return myReturn
    }
    
    
    var body: some View {
        VStack {
            Picker("Select restriction", selection: $restrictionName) {
                ForEach(getRestrictionNames(), id: \.self) { restrictionname in
                    Text(restrictionname)
                }
            }
            HStack {
                Button(action: {
                    let idx = rbb.sectionItem?.restrictions.firstIndex(of: restrictionName)
                    if idx == nil {
                        rbb.sectionItem?.restrictions.append(restrictionName)
                    }},
                       label: {
                    Image(systemName: "cross")
                    Text("Add")
                        .fontWeight(.bold)
                        .font(Font.system(size: 14, weight: .medium, design: .serif))
                    
                }).buttonStyle(.bordered)
                
                Button(action: {rbb.sectionItem?.restrictions = []},
                       label: {
                    Image(systemName: "circle")
                    Text("Reset")
                        .fontWeight(.bold)
                        .font(Font.system(size: 14, weight: .medium, design: .serif))
                    
                }).buttonStyle(.borderedProminent)
                
                Button(action: {
                    let idx = rbb.sectionItem?.restrictions.firstIndex(of: restrictionName)
                    if idx != nil {
                        rbb.sectionItem?.restrictions.remove(at: idx!)
                    }},
                       label: {
                    Image(systemName: "lasso")
                    Text("Remove")
                        .fontWeight(.bold)
                        .font(Font.system(size: 14, weight: .medium, design: .serif))
                    
                }).buttonStyle(.bordered)
            }.padding(5)
            
            VStack {
                Text(rbb.sectionItem?.restrictions.description ?? "No restrictions")
                Divider()
                ForEach(rbb.sectionItem?.restrictions ?? [], id: \.self) { name in
                    Text(getDescForName(name:name))
                    Divider()
                }
            }
            
            
//            Text(getRestrictionNames().firstIndex(of: restrictionName))
        }
    }
}

struct BuildRestrictionsView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRestrictionsView()
            .environmentObject(RecipeBeingBuilt())
    }
}
