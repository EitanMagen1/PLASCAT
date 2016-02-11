//
//  CSVBOMFiles.swift
//  PLASCAT
//
//  Created by Lauren Efron on 07/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import Foundation
import UIKit

class CSVBOMFiles {
    static let sheredInstance = CSVBOMFiles()
    var error: NSErrorPointer = nil
    
    // open the file functions
    func openBOMFile()-> CSwiftV {
        var rawInputString = ""
        // start searching only after the PN was entered corectly or more then 3 leters were entered
        let url = NSBundle.mainBundle().URLForResource( "PLS_LUL_BOM", withExtension: "csv")!
        do {
            rawInputString = try String( contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Error=", error)
        }
        let inputString = rawInputString.substringFromIndex(rawInputString.startIndex.advancedBy(110))
        
        let csv = CSwiftV(String: inputString)
        
        return csv
    }
    func searchInFile ( searchText : String, csv : CSwiftV) ->[Data] {
        let charectersNumber = searchText.characters.count
        
        var dataArray = [Data]()
        if  charectersNumber > 3 {
            
            guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
           
            for keyedrow in keyedRows {
                if keyedrow["Component Number"]!.containsString(searchText)
                
                {
                    
                    let itemNumber = "Component searched:\(keyedrow["Component Number"]!) \n"
                    let assemblyNumber = "Assembly Number:\(keyedrow["Assembly Number"]!) \n"
                    let engDescription = "English Desciption:\(keyedrow["Assembly Description"]!) \n"
                    let statusCode = "Status Code:\(keyedrow["Assembly Status Code"]!) \n"
                    let hebDescription = "Hebrew Description :\(keyedrow["Assembly Hebrew Description"]!) \n"
                    
                    let tempData = Data()
                    tempData.itemDescription = itemNumber + assemblyNumber + statusCode + engDescription + hebDescription
                    dataArray.append(tempData)
                    
                }
            }
            if dataArray == [] {
                let tempData = Data()
                tempData.itemDescription = "No Assembly Found"
                dataArray.append(tempData)
            }
        }
        return dataArray
    }
    
}

