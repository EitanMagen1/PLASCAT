//
//  CSVFiles.swift
//  PLASCAT
//
//  Created by Lauren Efron on 02/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

class CSVFiles {
    static let sheredInstance = CSVFiles()
    var error: NSErrorPointer = nil
    
    func testFile( searchText : String , SearchBy : Int)-> [Data] {
        var rawInputString = ""
        let charectersNumber = searchText.characters.count
        // start searching only after the PN was entered corectly or more then 3 leters were entered
        if  charectersNumber > 7  || (SearchBy == 1 && charectersNumber > 3 ){
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

        }
        return []
    }
    
    func testString() {
        let inputString =
        "ORG,Item Number,ENG Description,HEB Description,Status Code,Lifecycle Phase,Make / Buy,Unit Weight,Marketing Package,Pack Qty\r\n" +
            "PLS,02001025,NOT ACTIVE- POULTRY CRATE MK1. WITHOUT DOOR,NOT ACTIVE-- כלוב 1 קומ בלי דלת  יצוא,Inactive,Retirement,Buy,4.9,,0\r\n" +
            "PLS,02001026,POULTRY CRATE MK1. - BLUE W/DOOR,וב 1 קומ בלי דלת  יצוא,Active,Production,Buy,5.41,FMA,2\r\n" +
        "PLS,02001027,POULTRY CRATE MK1. - GREY W/DOOR,..כלוב 1,Active,Production,Buy,5.41,FMA,14\r\n"
        
        let csv = CSwiftV(String: inputString)
        
        let headers = csv.headers
        print("headers=\(headers)")
        
        let rows = csv.rows
        print("rows=\(rows)")
        
        guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return }
        print("keyedRows=\(keyedRows)")
    }
    
}


