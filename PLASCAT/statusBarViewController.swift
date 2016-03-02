//
//  statusBarViewController.swift
//  DownloadTaskWithNSURLSession
//
//  Created by Malek T. on 11/4/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//
/*
import UIKit

class statusBarViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    
    var downloadTask: NSURLSessionDownloadTask!
    var backgroundSession: NSURLSession!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func startDownload(sender: AnyObject) {
        let url = NSURL(string: downloadConstants.URLConstants.BaseURLForBOMFile)!
        downloadTask = backgroundSession.downloadTaskWithURL(url)
        downloadTask.resume()
    }
    @IBAction func pause(sender: AnyObject) {
        if downloadTask != nil{
            downloadTask.suspend()
        }
    }
    @IBAction func resume(sender: AnyObject) {
        if downloadTask != nil{
            downloadTask.resume()
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        if downloadTask != nil{
            downloadTask.cancel()
        }
    }
    
    
    @IBOutlet var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession")
        backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        progressView.setProgress(0.0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 1
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL){
            
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let fileManager = NSFileManager()
            let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/file.csv"))
            
            if fileManager.fileExistsAtPath(destinationURLForFile.path!){
                print("the file exists")
            }
            else{
                do {
                    try fileManager.moveItemAtURL(location, toURL: destinationURLForFile)
                    // show file
                    print("the file is was moved succesfully")
                }catch{
                    print("An error occurred while moving file to destination url")
                }
            }
    }
    // 2
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
            progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        downloadTask = nil
        progressView.setProgress(0.0, animated: true)
        if (error != nil) {
            print(error?.description)
        }else{
            print("The task finished transferring data successfully")
        }
        
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }
    
    
}
*/
