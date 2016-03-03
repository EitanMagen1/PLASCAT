//
//  historyTableViewController.swift
//  PLASCAT
//
//  Created by Lauren Efron on 03/03/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit
import Foundation

let CellId = "HistoryCell"

class historyTableViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var SearchPreference : String = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return searchArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataFound = searchArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId , forIndexPath: indexPath)
        
        cell.layer.cornerRadius = cell.frame.width / 12
        cell.clipsToBounds = true
        cell.textLabel!.text = dataFound
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataPicked = searchArray[indexPath.row]
        // if the press is the second one
            SearchPreference = dataPicked
            self.performSegueWithIdentifier("segueToSearch", sender: nil);

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToSearch" {
            let vc : SearchViewController = segue.destinationViewController as! SearchViewController
            vc.SearchFromHistoryTable = true
            vc.SearchPreference = SearchPreference
            
        }
    }
}
