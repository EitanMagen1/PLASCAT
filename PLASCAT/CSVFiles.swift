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

    var csv:CSV
    
    init() {
        let csvURL = NSBundle(forClass: CSVFiles.self).URLForResource("PLS_LUL", withExtension: "csv")
        csv = CSV(contentsOfFile: String(csvURL), error: nil)!
        //example
        getItemForItemNumber("02001025")
    }
    
    
    func getItemForItemNumber(itemNum: String)-> Dictionary<String, String>{
        let item:Dictionary<String, String> = Dictionary<String, String>()

        for row in csv.rows {
            if row["Item Number"] == itemNum {
                print("\(row)")
                return row
            }
        }
        
        return item
    }
    
}
