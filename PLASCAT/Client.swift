//
//  Client.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import Foundation

class Client {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    
    func updatingFilesFromServer(fileTypeToDowload : String) -> NSData{
        
        var components = NSURLComponents()
        var dataRecived = NSData()
        
        if fileTypeToDowload == "BaseURLForBOMFile" {
        components = NSURLComponents(string: downloadConstants.URLConstants.BaseURLForBOMFile)!
        } else if fileTypeToDowload == "BaseURLForLULFile" {
        components = NSURLComponents(string: downloadConstants.URLConstants.BaseURLForLULFile)!
        }
        let request = NSMutableURLRequest(URL: (components.URL)!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    
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
            dataRecived = data
            print("downlaoded the data succefuly ")

        }
        task.resume()
        return  dataRecived
    }
    
    
       
}