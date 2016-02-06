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
    
    func testFile( searchText : String )-> String {
        var inputString = ""
        let url = NSBundle.mainBundle().URLForResource( "PLS_LUL", withExtension: "csv")!
        do {
            inputString = try String( contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Error=", error)
        }
        let csv = CSwiftV(String: inputString)
        let headers = csv.headers
       // print("headers=\(headers)")
        
        let rows = csv.rows
       // print("row #3=\(rows[2])")
        //02387035
        guard let keyedRows = csv.keyedRows else { print("no keyedRows"); return "" }
       
            for keyedrow in keyedRows {
                if keyedrow["Item Number"] == searchText {
                    print("Item Number  :\(keyedrow["Item Number"]!)")
                    let itemNumber = "Item Number  :\(keyedrow["Item Number"]!)"
                    print("ENG Description  :\(keyedrow["ENG Description"]!)")
                    let engDescription = "ENG Description  :\(keyedrow["ENG Description"]!)"
                    return itemNumber + engDescription
                }
            
        }
      
        return ""
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
    
    func getItemForItemNumber(searchText : String){
        //working url to the file
        let csvURL = NSBundle(forClass: CSVFiles.self).URLForResource("PLS_LUL", withExtension: "csv")
        //missing a way to 
        //
        //test string seperated by commas
        let inputString = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00\r\n"
        
        let csv = CSwiftV(String: inputString)
        
        
        let rows = csv.rows
        print("\(rows)")
        //[
        //  ["1997","Ford","E350","descrition","3000.00"],
        //  ["1999","Chevy","Venture","another description","4900.00"]
        // ]
        
        let headers = csv.headers // ["Year","Make","Model","Description","Price"]
        
        let keyedRows = csv.keyedRows // [
        //  ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
        //  ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, description","Price":"4900.00"]
        // ]

    }
}


