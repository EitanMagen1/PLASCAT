//
//  downlaodProgressBar.swift
//  PLASCAT
//
//  Created by Lauren Efron on 25/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

class downlaodProgressBar: UIViewController  {
    
    
    let formatter = NSDateFormatter()
    let date = NSDate()
    
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        // get the last updated date from memory and present it
        updatedDateLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("updatedDateLabel.text")
        progressBar.setProgress(0, animated: true)
        downloadLabel.text = "Download Controller"
        
    }
    
    @IBAction func updateButton(sender: AnyObject) {
    downloadLabel.text = "Downloading Files"

    downloadFiles()
     
    }
    
    func downloadFiles(){
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DataExists")
        let dateString = formatter.stringFromDate(date)
        var resultLUL = Bool()
        var resultBOM = Bool()
        
        Client().updatingFilesFromServer("BaseURLForBOMFile"){ ( FileForBOM , error ) in
            if let error = error {
                self.downloadLabel.text = "error Downloading BOM Files \(error)"
                return
            }
            // i want to save the file to the document directory
            let URL = FindDucumentInDirectory("PLS_LUL_BOM.csv")
            resultBOM = FileForBOM.writeToFile(URL.path!, atomically: true)
            // save the BOM file name
            NSUserDefaults.standardUserDefaults().setValue("PLS_LUL_BOM.csv", forKey: "BOMFileName")
            if resultBOM {
                // save the date
                self.updatedDateLabel.text = "Last Updated " + dateString
                NSUserDefaults.standardUserDefaults().setObject(self.updatedDateLabel.text, forKey: "updatedDateLabel.text")
            }
        }
        
        Client().updatingFilesFromServer("BaseURLForLULFile"){ ( FileForLUL , error ) in
            if let error = error {
                self.downloadLabel.text = "error Downloading LUL Files \(error)"
                return
            }
            // i want to save the file to the document directory,
            let URL = FindDucumentInDirectory("PLS_LUL.csv")
            
            resultLUL = FileForLUL.writeToFile(URL.path!, atomically: true)
            // save the BOM file name
            NSUserDefaults.standardUserDefaults().setValue("PLS_LUL.csv", forKey: "LULFileName")
        }
    }
}

// helpwer method
func FindDucumentInDirectory (FileSearched :String)->NSURL{
    
    // NSURL of the documents directory on the device
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    
    //pinpoint a file in the documents directory
    let fileURL = documentsURL.URLByAppendingPathComponent(FileSearched)
    
    //destination URL For File defines the Path
    return fileURL
    
}
