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


