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
    
    func testFile( searchText : String)-> [Data] {
        var rawInputString = ""
        let charectersNumber = searchText.characters.count
        // start searching only after the PN was entered corectly or more then 3 leters were entered
        if  charectersNumber > 3 {
            let url = NSBundle.mainBundle().URLForResource( "PLS_LUL", withExtension: "csv")!
            do {
                rawInputString = try String( contentsOfURL: url, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                print("Error=", error)
            }
            let inputString = rawInputString.substringFromIndex(rawInputString.startIndex.advancedBy(110))
            
            let csv = CSwiftV(String: inputString)
            //let headers = csv.headers
            // print("headers=\(headers)")
            var dataArray = [Data]()
            
            //let rows = csv.rows
            // print("row #3=\(rows[2])")
            //02387035
            guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
            for keyedrow in keyedRows {
                if keyedrow["Item Number"]!.containsString(searchText) ||  keyedrow["ENG Description"]!.containsString(searchText) ||  keyedrow["HEB Description"]!.containsString(searchText) {
                    
                    print("Item Number  :\(keyedrow["Item Number"]!)")
                    let itemNumber = "Item Number  :\(keyedrow["Item Number"]!) \n"
                    print("ENG Description  :\(keyedrow["ENG Description"]!)")
                    let engDescription = "English Description  :\(keyedrow["ENG Description"]!) \n"
                    let statusCode = "Status Code:\(keyedrow["Status Code"]!) \n"
                    let hebDescription = "Hebrew Description :\(keyedrow["HEB Description"]!) \n"
                    let tempData = Data()
                    tempData.itemDescription = itemNumber + statusCode + engDescription + hebDescription
                    dataArray.append(tempData)
                    
                }
            }
            if dataArray == [] {
                let tempData = Data()
                tempData.itemDescription = "No items Found"
                dataArray.append(tempData)
            }
            return dataArray
            
        }
        return []
    }
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
        if  charectersNumber > 3 {
            
            guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
            for keyedrow in keyedRows {
                if keyedrow["Item Number"]!.containsString(searchText) ||  keyedrow["ENG Description"]!.containsString(searchText) ||  keyedrow["HEB Description"]!.containsString(searchText) {
                    
                    print("Item Number  :\(keyedrow["Item Number"]!)")
                    let itemNumber = "Item Number  :\(keyedrow["Item Number"]!) \n"
                    print("ENG Description  :\(keyedrow["ENG Description"]!)")
                    let engDescription = "English Description  :\(keyedrow["ENG Description"]!) \n"
                    let statusCode = "Status Code:\(keyedrow["Status Code"]!) \n"
                    let hebDescription = "Hebrew Description :\(keyedrow["HEB Description"]!) \n"
                    let tempData = Data()
                    tempData.itemDescription = itemNumber + statusCode + engDescription + hebDescription
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

