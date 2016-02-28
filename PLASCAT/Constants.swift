//
//  Constants.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import Foundation

// MARK: Enum to indicate client
enum ClientSelection {
    case Udacity
    case Parse
}

class downloadConstants {
    
    struct URLConstants {
        static let BaseURLForLULFile: String = "http://medan1.co.il/plascat/PLS_LUL.csv"
        static let BaseURLForBOMFile: String = "http://medan1.co.il/plascat/PLS_LUL_BOM.csv"

    }
    
    struct Parameters {
       // static let Order: String = "order"
        
    }
    
    struct HTTPFields {
     //   static let AppID: String = "X-Parse-Application-Id"
    }
    
    struct JSONKeys {
        /* GETting StudentLocations Response */
        static let Results = "results" //outer dictionary
        
        /* also POSTing StudentLocation Body keys */
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let UniqueKey = "uniqueKey" //also in POSTing StudentLocations
        static let ObjectID = "objectId" //also used in request to PUT (update) StudentLocation
        
        /* POSTing StudentLocations Response */
        static let CreatedAt = "createdAt"
        
        /* PUTting StudentLocations Response */
        static let UpdatedAt = "updatedAt"
    }
}

