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
    // indicates if we are downloading right now or not
    var isDownloading = false
    
    var downloadTask: NSURLSessionDownloadTask!
    var Session: NSURLSession!
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var downloadButton: UIButton!
    
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
        
        downloadFiles { (ResultLUL, ResultBOM) -> Void in
            if ResultLUL && ResultBOM {
                self.updateDonloadTimeStamp()
                self.updateLabel()
            }
        }
    }
    func updateLabel (){
        dispatch_async(dispatch_get_main_queue(),{
            self.updatedDateLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("updatedDateLabel.text")
            self.downloadButton.setTitle("Finished Downloading Files", forState: .Normal)
        })
    }
    func downloadFiles(completionHandler ResultHandler : (ResultLUL :Bool ,ResultBOM : Bool )->Void){
        var resultLUL = Bool()
        var resultBOM = Bool()
        Client().updatingFilesFromServer("BaseURLForLULFile"){ ( FileForLUL , error ) in
            if let error = error {
                UIViewController().presentError(error.debugDescription)
                return
            }
            // save the file to the document directory,
            let URL = FindDucumentInDirectory("PLS_LUL.csv")
            print( " We finished downloading the file LUL")
            if SearchViewController().dataExists {
            dispatch_async(dispatch_get_main_queue(),{
                
                self.progressBar.setProgress(0.3, animated: true)
                self.downloadLabel.text = "Downloaded LUL file 1/2"
            })
            }
            resultLUL = FileForLUL.writeToFile(URL.path!, atomically: true)
            // save the BOM file name
            NSUserDefaults.standardUserDefaults().setValue("PLS_LUL.csv", forKey: "LULFileName")
            
        }
        
        
        Client().updatingFilesFromServer("BaseURLForBOMFile"){ ( FileForBOM , error ) in
            if let error = error {
                UIViewController().presentError(error.debugDescription)
                return
            }
            if SearchViewController().dataExists {

            dispatch_async(dispatch_get_main_queue(),{
                
                self.progressBar.setProgress(1, animated: true)
                self.downloadLabel.text = "Downloaded BOM file 2/2"
            })
            }
            // i want to save the file to the document directory
            let URL = FindDucumentInDirectory("PLS_LUL_BOM.csv")
            
            
            resultBOM = FileForBOM.writeToFile(URL.path!, atomically: true)
            // save the BOM file name
            NSUserDefaults.standardUserDefaults().setValue("PLS_LUL_BOM.csv", forKey: "BOMFileName")
            ResultHandler(ResultLUL: resultLUL , ResultBOM: resultBOM)

        }
        return
    }
    
    
    
    
    //MARK  - save download date
    
    func updateDonloadTimeStamp(){
        let date = NSDate()
        let dateString = formatter.stringFromDate(date)
        let textForLabel = "Last Updated " + dateString
        NSUserDefaults.standardUserDefaults().setObject(textForLabel, forKey: "updatedDateLabel.text")
        
        
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
    
    
}

//  MARK - helper method
func FindDucumentInDirectory (FileSearched :String)->NSURL{
    
    // NSURL of the documents directory on the device
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
    
    //pinpoint a file in the documents directory
    let fileURL = documentsURL.URLByAppendingPathComponent(FileSearched)
    
    //destination URL For File defines the Path
    return fileURL
    
}
