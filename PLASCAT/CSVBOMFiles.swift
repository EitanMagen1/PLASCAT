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
        if  charectersNumber > 4 {
            
            guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
            var assemblyNumber = ""
            var assemblyNumberOnly = ""
            var engDescription = ""
            var statusCode = ""
            var hebDescription = ""
            var PLSblocker = false
            for keyedrow in keyedRows {
                //goes over all of the assemblies
                if keyedrow["Assembly Number"] != "" {
                    assemblyNumber = "Assembly Number:\(keyedrow["Assembly Number"]!) \n"
                    assemblyNumberOnly = "\(keyedrow["Assembly Number"]!)"

                    engDescription = "English Desciption:\(keyedrow["Assembly Description"]!) \n"
                    statusCode = "Status Code:\(keyedrow["Assembly Status Code"]!) \n"
                    hebDescription = "Hebrew Description :\(keyedrow["Assembly Hebrew Description"]!) \n"
                    
                }
                // prevent second count
                if keyedrow["ORG"] == "PLS" {
                    PLSblocker = true
                } else if keyedrow["ORG"] == "MST" {
                    PLSblocker = false
                }
                
                if keyedrow["Assembly Number"]!.containsString(searchText) || keyedrow["Assembly Description"]!.containsString(searchText) {
                    let itemSearched = "Component searched:\(searchText) \n"
                    let tempData = Data()
                    tempData.itemDescription = itemSearched + assemblyNumber + statusCode + engDescription + hebDescription
                    tempData.ItemNumber = assemblyNumberOnly
                    
                    dataArray.append(tempData)
                }

                if keyedrow["Component Number"]!.containsString(searchText) && PLSblocker == false || keyedrow["Component Description"]!.containsString(searchText) && PLSblocker == false || keyedrow["Component Hebrew Description"]!.containsString(searchText) && PLSblocker == false {
                    let itemSearch = "Component searched: \(searchText) \n"
                    let itemPN = "Component Number: \(keyedrow["Component Number"]!)"
                    let tempData = Data()
                    tempData.itemDescription = itemSearch + assemblyNumber + statusCode + engDescription + hebDescription + itemPN
                    tempData.ItemNumber = assemblyNumberOnly

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
    func searchInFileForAssembly ( searchText : String, csv : CSwiftV) ->[Data] {
        
        var dataArray = [Data]()
        guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return [] }
        var assemblyNumber = ""
        var engDescription = ""
        var statusCode = ""
        var hebDescription = ""
        var UsePLSAsExitPoint = false
        for keyedrow in keyedRows {
            //goes over all of the assemblies
            if keyedrow["Assembly Number"] == searchText {
                assemblyNumber = "Assembly Number:\(keyedrow["Assembly Number"]!) \n"
                engDescription = "English Desciption:\(keyedrow["Assembly Description"]!) \n"
                statusCode = "Status Code:\(keyedrow["Assembly Status Code"]!) \n"
                hebDescription = "Hebrew Description :\(keyedrow["Assembly Hebrew Description"]!) \n"
                let tempData = Data()
                tempData.itemDescription = assemblyNumber + engDescription + hebDescription + statusCode
                dataArray.append(tempData)
                UsePLSAsExitPoint = true
            }
            
            if UsePLSAsExitPoint == true {
                if keyedrow["ORG"] == "PLS" {
                    break
                }
                let itemNumber = "Item Number :\(keyedrow["Component Number"]!) \n"
                let engDescription = "English Description  :\(keyedrow["Component Description"]!) \n"
                let hebDescription = "Hebrew Description :\(keyedrow["Component Hebrew Description"]!) \n"
                let tempData = Data()
                tempData.itemDescription = itemNumber + engDescription + hebDescription
                dataArray.append(tempData)

                
            }
        }
        
        if dataArray == [] {
            let tempData = Data()
            tempData.itemDescription = "No Assembly Found"
            dataArray.append(tempData)
        }
        
        return dataArray
    }
}

