//
//  CSVPNFiles.swift
//  PLASCAT
//
//  Created by Lauren Efron on 02/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

class CSVPNFiles {
    static let sheredInstance = CSVPNFiles()
    var error: NSErrorPointer = nil
    
    // open the file functions
    func openLULFile()-> CSwiftV {
        var rawInputString = ""
        // start searching only after the PN was entered corectly or more then 3 leters were entered
        let url = NSBundle.mainBundle().URLForResource( "PLS_LUL", withExtension: "csv")!
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
        if  charectersNumber > 2 {
            
            guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
            for keyedrow in keyedRows {
                if keyedrow["Item Number"]!.containsString(searchText) ||  keyedrow["ENG Description"]!.containsString(searchText) ||  keyedrow["HEB Description"]!.containsString(searchText) {
                    
                    let itemNumber = "\(keyedrow["Item Number"]!) \n"
                    let engDescription = "\(keyedrow["ENG Description"]!) \n"
                    let statusCode = "\(keyedrow["Status Code"]!) \n"
                    let hebDescription = "\(keyedrow["HEB Description"]!) \n"
                    
                    let tempData = Data()
                    tempData.itemDescription = itemNumber + engDescription + hebDescription + statusCode
                    tempData.ItemNumber = "\(keyedrow["Item Number"]!) \n"
                    dataArray.append(tempData)
                    
                }
            }
            if dataArray == [] {
                let tempData = Data()
                tempData.itemDescription = "No items Found"
                dataArray.append(tempData)
            }
        }
        return dataArray
    }
    
}

