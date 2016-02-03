//
//  CSVFiles.swift
//  PLASCAT
//
//  Created by Lauren Efron on 02/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

class CSVFiles: NSObject {
    
    let csvURL = NSBundle.URLForResource("PLS_LUL", withExtension: "csv")
    do {
    csv = try CSV(contentsOfURL: csvURL!)
    }
    catch let error1 as NSError {
    error.memory = error1            csv = nil        }
}
