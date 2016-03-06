//
//  downlaodProgressBar.swift
//  PLASCAT
//
//  Created by Lauren Efron on 25/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit


class downlaodProgressBar: UIViewController , NSURLSessionDownloadDelegate  {
    

    // property to keep track of the persentage wise we pulled down
    var progressPercentage: Float64 = 0
    weak var delegate: DownloadViewDelegate?
    // indicates if we are refreshing right now or not
    var isDownloading = false
    var downloadTask: NSURLSessionDownloadTask!
    var Session: NSURLSession!

    
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
        downloadLabel.text = "Downloading Files 0/2"
        progressBar.setProgress(0, animated: true)

        downloadFiles()
        
    }
    
    
    
    // 1
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL){
            print("changed")
                }
    // 2
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
            progressBar.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        downloadTask = nil
        progressBar.setProgress(0.0, animated: true)
        if (error != nil) {
            print(error?.description)
        }else{
            print("The task finished transferring data successfully")
        }
        
    }
    
    
    
    func downloadFiles(){
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DataExists")
        let dateString = formatter.stringFromDate(date)
        var resultLUL = Bool()
        var resultBOM = Bool()
        Client().updatingFilesFromServer("BaseURLForLULFile"){ ( FileForLUL , error ) in
            if let error = error {
                self.downloadLabel.text = "error Downloading LUL Files \(error)"
                return
            }
            // save the file to the document directory,
            let URL = FindDucumentInDirectory("PLS_LUL.csv")
            print( " We finished downloading the file LUL")
            
            resultLUL = FileForLUL.writeToFile(URL.path!, atomically: true)
            // save the BOM file name
            NSUserDefaults.standardUserDefaults().setValue("PLS_LUL.csv", forKey: "LULFileName")
        }
        self.progressBar.setProgress(0.3, animated: true)
        self.downloadLabel.text = "Downloaded LUL file 1/2"

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
        self.progressBar.setProgress(1.0, animated: true)
        self.downloadLabel.text = "Downloaded files successfully 2/2"
        
        
    }
}

// helpwer method
func FindDucumentInDirectory (FileSearched :String)->NSURL{
    
    // NSURL of the documents directory on the device
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
    
    //pinpoint a file in the documents directory
    let fileURL = documentsURL.URLByAppendingPathComponent(FileSearched)
    
    //destination URL For File defines the Path
    return fileURL
    
}
