//
//  MeasuresView.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 1/25/24.
//

import SwiftUI

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

#Preview {
    MeasuresView(measures: Measures.measuresExample)
}

/*
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
 */
