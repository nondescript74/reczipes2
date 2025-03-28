//
//  NutritionEditor.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 6/14/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//
import SwiftUI

struct NutritionEditor: View {
    // MARK: - Binding
    @Binding var nutrition: Nutrition
    // MARK: - Environment Variables
    @Environment(UserData.self) private var userData
    // MARK: - State
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(" Max Sodium: ")
        }
    }
}


struct NutritionEditor_Previews: PreviewProvider {
    static var previews: some View {
        NutritionEditor(nutrition: .constant(.default))
            .environment(\.colorScheme, .dark)
            .previewDevice("iPhone Xr")
            .environment(UserData())
    }
}

