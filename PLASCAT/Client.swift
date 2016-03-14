//
//  Client.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import Foundation

// protocol that lets the delegate know the user wants to refresh the data
protocol DownloadViewDelegate: class {
    func downlaodViewDidchange(downloadView: Client)
}

class Client {
    
    // MARK: Properties
    weak var delegate:DownloadViewDelegate?
    
    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    init() {
        session = NSURLSession.sharedSession()
        
    }
    
    func updatingFilesFromServer(fileTypeToDowload : String , completionHandler DowloadingFiles : (result : NSData!, error :NSError?)-> Void) -> NSURLSessionDataTask{
        

        var components = NSURLComponents()
        
        if fileTypeToDowload == "BaseURLForBOMFile" {
            components = NSURLComponents(string: downloadConstants.URLConstants.BaseURLForBOMFile)!
        } else if fileTypeToDowload == "BaseURLForLULFile" {
            components = NSURLComponents(string: downloadConstants.URLConstants.BaseURLForLULFile)!
        }
        let request = NSMutableURLRequest(URL: (components.URL)!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            /* GUARD: Was there an error? */
            self.delegate?.downlaodViewDidchange(self)
            
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                DowloadingFiles(result: nil, error: error )
                
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    DowloadingFiles(result: nil, error: response as? NSError )
                    
                    
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            //dataRecived = data
            print("downlaoded the data succefuly ")
            DowloadingFiles(result: data, error: nil)
        }
        
        task.resume()
        
        return task
            
    }
    
  
    
}