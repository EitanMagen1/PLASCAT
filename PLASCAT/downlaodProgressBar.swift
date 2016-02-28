//
//  downlaodProgressBar.swift
//  PLASCAT
//
//  Created by Lauren Efron on 25/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

class downlaodProgressBar: UIViewController {
    
    let formatter = NSDateFormatter()
    let date = NSDate()

    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        // get the last updated date from memory and present it
        updatedDateLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("updatedDateLabel.text")
        progressBar.setProgress(0, animated: true)
    }
    
    @IBAction func updateButton(sender: AnyObject) {
        
        let dateString = formatter.stringFromDate(date)
        updatedDateLabel.text = "Last Updated " + dateString
        let FileForBOM = Client().updatingFilesFromServer("BaseURLForBOMFile")
        let FileForLUL = Client().updatingFilesFromServer("BaseURLForLULFile")
        
        NSUserDefaults.standardUserDefaults().setObject(FileForBOM, forKey: "PLS_LUL_BOM.csv")
        NSUserDefaults.standardUserDefaults().setObject(FileForLUL, forKey: "PLS_LUL.csv")
        NSUserDefaults.standardUserDefaults().setObject(updatedDateLabel.text, forKey: "updatedDateLabel.text")

    }
}
