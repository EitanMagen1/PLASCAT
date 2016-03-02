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
        var url = NSURL()
        let FileName = NSUserDefaults.standardUserDefaults().valueForKey("LULFileName")
        url = FindDucumentInDirectory("\(FileName!)")

        do {
            rawInputString = try String( contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Error=", error)
        }
        let inputString = rawInputString.substringFromIndex(rawInputString.startIndex.advancedBy(110))
        
        let csv = CSwiftV(String: inputString)
        
        return csv
    }
    
    func searchInFile ( searchText : String, csv : CSwiftV , charectersToSkip : Int) ->[Data] {
        
        let charectersNumber = searchText.characters.count
        var dataArray = [Data]()
        if  charectersNumber > charectersToSkip {
            
            guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
            for keyedrow in keyedRows {
                if keyedrow["Item Number"]!.containsString(searchText) ||  keyedrow["ENG Description"]!.containsString(searchText) ||  keyedrow["HEB Description"]!.containsString(searchText) {
                    
                    let itemNumber = "\(keyedrow["Item Number"]!) \n"
                    let engDescription = "\(keyedrow["ENG Description"]!) \n"
                    let extra = "\(keyedrow["Status Code"]!)," + " Unit Weight: \(keyedrow["Unit Weight"]!)," + " Marketing Package : \(keyedrow["Marketing Package"]!) \n" + "Package Qty:  \(keyedrow["Pack Qty"]!)"
                    let hebDescription = "\(keyedrow["HEB Description"]!) \n"
                    
                    let tempData = Data()
                    tempData.itemDescription = itemNumber + engDescription + hebDescription + extra
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

