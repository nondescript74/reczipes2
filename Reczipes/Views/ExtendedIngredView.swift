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
        var myReturnMetaInfo: String = "meta:"
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
        }
    }
}

struct ImageAndNameView: View {
    // MARK: - Initializer
    init(extendedIngredient: ExtendedIngredient) {
        self.myExtIngredient = extendedIngredient
    }
    // MARK: - Properties
    fileprivate var myExtIngredient: ExtendedIngredient!
    fileprivate var myExtIngRatio: Double = 1.0
    private enum msgs: String {
        case noIngredName = "No Ingredient Name??"
    }
    // MARK: Methods
    // MARK: - View Process
    var body: some View {
        HStack(alignment: .center) {
            ImageWithSectionItemView(extendedIngredient: myExtIngredient)
                Spacer()
            Text(myExtIngredient.name ?? msgs.noIngredName.rawValue)
                .font(.headline)
                //.foregroundColor(.blue)
                .padding()
        }
    }
}

//struct MeasureView: View {
//    // MARK: - Initializer
//    init(measure: Measure) {
//        self.myMeasure = measure
//    }
//    // MARK: - Properties
//    fileprivate var myMeasure: Measure!
//    private enum msgs: String {
//        case noAmount = "No amount??"
//        case noUnitShort = "No unitShort??"
//        case noUnitLong = "No unitLong??"
//    }
//    var body: some View {
//        HStack(alignment: .top) {
//            Text(myMeasure.amount?.description ?? msgs.noAmount.rawValue)
//            Text(myMeasure.unitLong ?? msgs.noUnitLong.rawValue)
//        }
//    }
//}

struct MeasuresView: View {
    // MARK: - Initializer
    init(measures: Measures) {
        self.myMeasures = measures
    }
    // MARK: - EnvironmentObjects
    @EnvironmentObject var ratio: RecipeRatio
    // MARK: - Properties
    fileprivate var myMeasures: Measures!
    // MARK: - State
    // MARK: - Methods
    fileprivate func makeRatiodUS() -> Text {
        let test = myMeasures.us?.amount?.description ?? "0"
        let testUnits = myMeasures.us?.unitLong ?? "pounds?"
        var testResult: Double = 0
        var testResultUnits: String = testUnits
        switch test {
        case 0.description:
            break
        default:
            testResult = (myMeasures.us?.amount)! * ratio.ratio
            testResult = testResult.rounded()
        }
        switch testResultUnits {
        case "pounds?":
            break
        default:
            testResultUnits = (myMeasures.us?.unitLong)!
        }
        let value = Text(testResult.description) + Text(" ") + Text(testResultUnits)
        return value
    }
    fileprivate func makeRatiodMetric() -> Text {
        let test = myMeasures.metric?.amount?.description ?? "0"
        let testUnits = myMeasures.metric?.unitLong ?? "kilos?"
        var testResult: Double = 0
        var testResultUnits: String = testUnits
        switch test {
        case 0.description:
            break
        default:
            testResult = (myMeasures.metric?.amount)! * ratio.ratio
            testResult = testResult.rounded()
        }
        switch testResultUnits {
        case "kilos?":
            break
        default:
            testResultUnits = (myMeasures.metric?.unitLong)!
        }
        let value = Text(testResult.description) + Text(" ") + Text(testResultUnits)
        return value
    }
    // MARK: - View Process
    var body: some View {
        HStack {
            makeRatiodUS() + Text(" or ") + makeRatiodMetric()
        }.edgesIgnoringSafeArea(.all)
    }
}


struct MeasuresView_Previews: PreviewProvider {
    static let myExtendedIngredient: ExtendedIngredient = ExtendedIngredient.extendedIngredientExample
    static var previews: some View {
        Group {
            //MeasureView(measure: Measure.measureExampleUS)
            //MeasuresView(measures: Measures.measuresExample)
            ExtendedIngredView(extendedIngredient: myExtendedIngredient)
        }
    }
}

