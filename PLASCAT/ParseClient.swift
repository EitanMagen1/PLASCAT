//
//  ParseClient.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen. All rights reserved.
//

import Foundation

class ParseClient : Client {
    
    /* Shared instance */
    static let sharedInstance = ParseClient()
    
    private var objectID : String? = nil
    
    func UpdateFilesFromNetwork( )  {
        
        let components = NSURLComponents(string: ParseClient.URLConstants.BaseURLForBOMFile)
        let request = NSMutableURLRequest(URL: (components?.URL)!)
        
        sessionAndParseTask(request) { (result, error) -> Void in
            if error == nil {
                if let result = result as! [String:AnyObject]? {
                    completionHandler(result: result, errorString: nil)
                } else {
                    completionHandler(result: nil, errorString: "StudentLocation fail (GET): reading response from Parse")
                }
            } else if let error = error {
                completionHandler(result: nil, errorString: error.description)
            }
        }
        return request
    }
    
    
// MARK: Convenience methods for ParseClient
    
    func getObjectID() -> String? {
        return objectID
    }
    
}