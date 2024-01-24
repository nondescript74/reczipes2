//
//  AnalyzedInstructionsCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import Foundation

protocol AnalyzedInstructionsCreateOperationDataProvider {
    var data:Data? { get }
}

class AnalyzedInstructionsCreateOperation: Operation {
    // MARK: - Debug local
    private var zBug: Bool = true
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: ((AnalyzedInstructions?) -> ())?
    fileprivate var myAnalyInstr: AnalyzedInstructions?
    fileprivate enum msgs: String {
        case aico = "AnalyzedInstructionsCreateOperation: "
        case ai = " analyzedInstructions: "
        case cantDecode = " cannot decode AnalyzedInstructions from myData "
        case success = "AnalyzedInstructionsCreateOperation created an AnalyzedInstructions "
        case mydata = "myData "
    }
    // MARK: - Initializer
    init(data: Data?, completion: ((AnalyzedInstructions?) -> ())? = nil) {
        inputData = data
        self.completion = completion
        super.init()
    }
    
    override func main() {
        
        if self.isCancelled { return }
        let myData: Data?
        
        if let inputData = inputData {
            myData = inputData
        } else {
            let dataProvider = dependencies
                .filter { $0 is AnalyzedInstructionsCreateOperationDataProvider }
                .first as? AnalyzedInstructionsCreateOperationDataProvider
            myData = dataProvider?.data
        }
        
        guard myData != nil else { 
            if zBug { print(msgs.aico.rawValue + msgs.mydata.rawValue, "myData is nil")}
            return }
        
        
        if zBug { print(msgs.aico.rawValue + msgs.mydata.rawValue, myData.debugDescription)}
        
        
        if self.isCancelled { return }
        
        do {
            let ai = try JSONDecoder().decode(AnalyzedInstructions.self, from: myData!)
            myAnalyInstr = ai
            
            if zBug { print(msgs.aico.rawValue + msgs.ai.rawValue, ai)}
            
        } catch {
            
            if zBug { print("Error took place\(error.localizedDescription).") }
            
            fatalError(msgs.aico.rawValue + msgs.cantDecode.rawValue)
        }
        
        
        if zBug { print(msgs.success.rawValue, myAnalyInstr.debugDescription) }
        
        
        if self.isCancelled { return }
        completion?(myAnalyInstr)
    }
    
}

extension AnalyzedInstructionsCreateOperation: AnalyzedInstructionsOutputOperationDataProvider, AnalyzedInstructionsXOperationDataProvider {
    var analyzInstr: AnalyzedInstructions? {
        return myAnalyInstr
    }
}

