//
//  historyTableViewController.swift
//  PLASCAT
//
//  Created by Lauren Efron on 03/03/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit
import Foundation
import CoreData

let CellId = "HistoryCell"

class historyTableViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource , NSFetchedResultsControllerDelegate {
    
    var searchArray = [Search]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 3: initialize the events array with the results of the fetchAllEvents() method
        searchArray = fetchAllEvents()
        
    }
    
    func insertNewObject(sender: AnyObject) {
        
        // Step 4: Create an Search object (and append it to the events array.)
        
        let newSearch = Search(context: sharedContext)
        newSearch.searchItem = sender as! String
        
        searchArray.append(newSearch)
        
        // Step 5: Save the context (and check for an error)
        var error: NSError?
        
        do {
            try sharedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("error saving context: \(error)")
        }
        
    }
    
    // var SearchPreference : String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Core Data Fetch Helpers
    
    // Step 1: Add a "sharedContext" convenience property.
    var sharedContext: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    // Step 2: Add a fetchAllEvents() method
    func fetchAllEvents() -> [Search] {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Search", inManagedObjectContext: sharedContext)
        var error: NSError? = nil
        
        fetchRequest.entity = entity
        
        // This is a little bit fancy. Adding a sort descriptor to the fetch request
        // gives us some control over. We will see more ways to enhance fetch requests
        // in Lesson 4
        let sortDescriptor = NSSortDescriptor(key: "searchItem", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var results: [AnyObject]?
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        
        if let error = error {
            print("Error fetching events: \(error)")
            return [Search]()
        }
        
        return results as! [Search]
    }
    // MARK Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataFound = searchArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId , forIndexPath: indexPath)
        
        cell.layer.cornerRadius = cell.frame.width / 12
        cell.clipsToBounds = true
        cell.textLabel!.text = dataFound.searchItem
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataPicked = searchArray[indexPath.row]
        SearchFromHistoryTable = true
        SearchPreference = dataPicked.searchItem
        navigationController!.popViewControllerAnimated(true)
    }
    
}
