//
//  CSVBomFiles.swift
//  PLASCAT
//
//  Created by Lauren Efron on 07/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import Foundation

class CSVBomFiles {
    static let sheredInstance = CSVBomFiles()
    var error: NSErrorPointer = nil
    
    func BOMFile( searchText : String , SearchBy : Int)-> [Data] {
        var rawInputString = ""
        let ChoosenItem = ""//add choosen data
        let url = NSBundle.mainBundle().URLForResource( "PLS_LUL_BOM", withExtension: "csv")!
        do {
            rawInputString = try String( contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Error=", error)
        }
        //skip the unreadable headline of the file as it arives from the data base
        let inputString = rawInputString.substringFromIndex(rawInputString.startIndex.advancedBy(110))
        
        let csv = CSwiftV(String: inputString)
        
        var dataArray = [Data]()
        
        guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
        for keyedrow in keyedRows {
            if ( keyedrow["Item Number"] == searchText && SearchBy == 0 ) || (( keyedrow["ENG Description"]!.containsString(searchText) ||  keyedrow["HEB Description"]!.containsString(searchText)) && SearchBy == 1 ) {
                
                print("Item Number  :\(keyedrow["Item Number"]!)")
                let itemNumber = "Item Number  :\(keyedrow["Item Number"]!) \n"
                print("ENG Description  :\(keyedrow["ENG Description"]!)")
                let engDescription = "English Description  :\(keyedrow["ENG Description"]!) \n"
                let statusCode = "Status Code:\(keyedrow["Status Code"]!) \n"
                let hebDescription = "Hebrew Description :\(keyedrow["HEB Description"]!) \n"
                let tempData = Data()
                tempData.itemDescription = itemNumber + statusCode + engDescription + hebDescription
                dataArray.append(tempData)
                if SearchBy == 0 {
                    return dataArray
                }
            }
        }
        return dataArray
        
        
        return []
        
    }
}
