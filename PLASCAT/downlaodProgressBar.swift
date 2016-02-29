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
        
        // NSURL of the documents directory on the device
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        //pinpoint a file in the documents directory
        let fileURLBOM = documentsURL.URLByAppendingPathComponent("PLS_LUL_BOM.csv")
        let fileURLLUL = documentsURL.URLByAppendingPathComponent("PLS_LUL_BOM.csv")
        
        //defines the Path
        let filePathBOM = fileURLBOM.path!
        let filePathLUL = fileURLLUL.path!
        
        // bool if writing was succesfull
        let resultBOM = FileForBOM.writeToFile(filePathBOM, atomically: true)
        let resultLUL = FileForLUL.writeToFile(filePathLUL, atomically: true)
        
        //get the files back
        print(resultBOM)
        
        NSUserDefaults.standardUserDefaults().setObject(fileURLBOM, forKey: "PLS_LUL_BOM.csv")
        NSUserDefaults.standardUserDefaults().setObject(fileURLLUL, forKey: "PLS_LUL.csv")
        NSUserDefaults.standardUserDefaults().setObject(updatedDateLabel.text, forKey: "updatedDateLabel.text")
        
    }
}
