//
//  NutritionHost.swift
//  CRecipes
//
//  Created by Zahirudeen Premji on 6/14/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI
import CoreData

struct NutritionHost: View {
    
    // MARK; - Debug
    var zBug:Bool = false
    
    // MARK:- Environment
    @Environment(\.editMode) var mode
    @EnvironmentObject var userData: UserData
    
    // MARK: - ManagedObjectContext
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    //MARK: - State
    @State var draftNutrition = Nutrition.default
    
    // MARK: - Methods
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftNutrition = self.userData.nutrition
                        self.mode?.animation().wrappedValue = .inactive
                        
                    }
                }
                
                Spacer()
                
                EditButton()
                    .onAppear {
                        if self.zBug {print("Onappear draftNutrition: ", self.draftNutrition, " userData.profile: ", self.userData.nutrition)}}
                    .onDisappear {
                        if self.zBug {print("OnDisappear draftNutrition: ", self.draftNutrition, " userData.profile: ", self.userData.nutrition)}}
                
            }
            if self.mode?.wrappedValue == .inactive {
                NutritionSummary(nutrition: self.userData.nutrition)
            } else {
                NutritionEditor(nutrition: $draftNutrition)
                    .onAppear {
                        if self.zBug {print("Before draftNutrition: ", self.draftNutrition, " userData.nutrition: ", self.userData.nutrition)}
                        self.draftNutrition = self.userData.nutrition
                }
                .onDisappear {
                    self.userData.nutrition = self.draftNutrition
                    if self.zBug {print("After draftNutrition: ", self.draftNutrition, " userData.nutrition: ", self.userData.nutrition)}
                }
            }
        }
        .padding()
    }
}

struct NutritionHost_Previews: PreviewProvider {
    static var previews: some View {
        NutritionHost().environmentObject(UserData())
    }
}

