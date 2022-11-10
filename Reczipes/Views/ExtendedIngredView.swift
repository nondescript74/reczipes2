//
//  ExtendedIngredView.swift
//  ZTester4
//
//  Created by Zahirudeen Premji on 11/22/20.
//

import SwiftUI

struct ExtendedIngredView: View {
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.myExtIngredient = extendedIngredient
    }
    // MARK: - EnvironmentObjects
    @EnvironmentObject var ratio: RecipeRatio
    // MARK: - Properties
    fileprivate var myExtIngredient: ExtendedIngredient!
    // MARK: - Methods
    fileprivate func getMetaInfo(meta: [String?]?) -> String {
        var myReturnMetaInfo: String = ""
        if meta != nil {
            if !meta!.isEmpty {
                for item in meta! {
                    myReturnMetaInfo += item!
                    myReturnMetaInfo += ", "
                }
            } else {
                myReturnMetaInfo = "meta: empty"
            }
        } else {
            
        }
        return myReturnMetaInfo
    }
    // MARK: - View Process
    var body: some View {
        VStack(alignment: .leading) {
            ImageAndNameView(extendedIngredient: myExtIngredient)
            MeasuresView(measures: myExtIngredient.measures ?? Measures.measuresExample)
            Text(getMetaInfo(meta: myExtIngredient.metaInformation))
        }.padding()
    }
}

struct ExtendedIngredView_Previews: PreviewProvider {
    static let myExtendedIngredient: ExtendedIngredient = ExtendedIngredient.extendedIngredientExample
    static let ratio = RecipeRatio()
    static var previews: some View {
        ExtendedIngredView(extendedIngredient: myExtendedIngredient)
            .environmentObject(ratio)
    }

}

struct ImageAndNameView: View {
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.myExtIngredient = extendedIngredient
    }
    // MARK: - Properties
    fileprivate var myExtIngredient: ExtendedIngredient!
//    fileprivate var myExtIngRatio: Double = 1.0
    private enum msgs: String {
        case noIngredName = "No Ingredient Name??"
    }
    // MARK: Methods
    // MARK: - View Process
    var body: some View {
        HStack(alignment: .center) {
            ImageWithSectionItemView(extendedIngredient: myExtIngredient)
            Text(myExtIngredient.name ?? msgs.noIngredName.rawValue)
                .font(.headline)
                .padding(.leading)
        }
    }
}

struct ImageAndNameView_Previews: PreviewProvider {
    static let myExtendedIngredient: ExtendedIngredient = ExtendedIngredient.extendedIngredientExample
    static var previews: some View {
        ImageAndNameView(extendedIngredient: ExtendedIngredient.extendedIngredientExample)
    }
}

struct MeasuresView: View {
    // MARK: - Initializer
    init(measures: Measures) {
        self.myMeasures = measures
    }
    // MARK: - EnvironmentObjects
    @EnvironmentObject var ratio: RecipeRatio
    // MARK: - Properties
    fileprivate var myMeasures: Measures!
    fileprivate var formatter: NumberFormatter = NumberFormatter()
    // MARK: - State
    // MARK: - Methods
    fileprivate func makeRatiodUS() -> Text {
        formatter.maximumSignificantDigits = 2
        formatter.generatesDecimalNumbers = true
        let test = myMeasures.us?.amount ?? 0.0
        let testUnits = myMeasures.us?.unitLong ?? "pounds?"
        var testResult: Double = 0
        var testResultUnits: String = testUnits
        switch test {
        case 0.0:
            break
        default:
            testResult = (myMeasures.us?.amount)! * ratio.ratio
        }
        let testResultStr = formatter.string(from: testResult as NSNumber) ?? "0.00"
        switch testResultUnits {
        case "pounds?":
            break
        default:
            testResultUnits = (myMeasures.us?.unitLong)!
        }
        let value = Text(testResultStr) + Text(" ") + Text(testResultUnits)
        return value
    }
    fileprivate func makeRatiodMetric() -> Text {
        let test = myMeasures.metric?.amount ?? 0.0
        let testUnits = myMeasures.metric?.unitLong ?? "kilos?"
        var testResult: Double = 0
        var testResultUnits: String = testUnits
        switch test {
        case 0.0:
            break
        default:
            testResult = (myMeasures.metric?.amount)! * ratio.ratio
        }
        let testResultStr = formatter.string(from: testResult as NSNumber) ?? "0.00"
        switch testResultUnits {
        case "kilos?":
            break
        default:
            testResultUnits = (myMeasures.metric?.unitLong)!
        }
        let value = Text(testResultStr) + Text(" ") + Text(testResultUnits)
        return value
    }
    // MARK: - View Process
    var body: some View {
        HStack {
            makeRatiodUS() + Text(" or ") + makeRatiodMetric()
        }
    }
}


struct MeasuresView_Previews: PreviewProvider {
    static let ratio = RecipeRatio()
    static let myExtendedIngredient: ExtendedIngredient = ExtendedIngredient.extendedIngredientExample
    static var previews: some View {
        Group {
            ExtendedIngredView(extendedIngredient: myExtendedIngredient)
        }.environmentObject(ratio)
    }
}




