//
//  SearchViewController.swift
//  PLASCAT
//
//  Created by Lauren Efron on 28/01/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit
import Foundation

let CellReuseId = "SearchCell"



class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    static let sheredInstance = SearchViewController()
    var csv = CSVPNFiles.sheredInstance.openLULFile()

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.ActivityIndicator.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.becomeFirstResponder()
        
    }
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SegmentedPNOrAssembly: UISegmentedControl!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch SegmentedPNOrAssembly.selectedSegmentIndex
        {
        case 0:
            searchBar.text = ""
            searchBar.placeholder = "Search Catalog By Catalog Number"
        case 1:
            searchBar.text = ""
            searchBar.placeholder = "Search Catalog By BOM"
            
        default:
            break;
        }
    }
    
    // The data for the table.
    var dataArray = [Data]()
    
    var searchTask: NSURLSessionDataTask?
    
    // MARK: - Search Bar Delegate
        
    // Each time the search text changes we want to cancel any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        // Cancel the last task
        if let task = searchTask {
            task.cancel()

            return
        }
        //delay function
        /*
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
        //put your code which should be executed with a delay here
        }
        */
      //  NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "getHints", object: nil)
    
        // If the text is empty we are done
        if searchText == "" {
           // self.ActivityIndicator.hidden = true
          //  self.ActivityIndicator.stopAnimating()
            dataArray = [Data]()
            tableView?.reloadData()
            objc_sync_exit(self)
            return
        }
        
        // Start a new one download
        dispatch_async(dispatch_get_main_queue()) {
            print("\(searchText)")
            
            let searchTextCapital = searchText.uppercaseString
            let searchTextNoLeadingZero = self.trimLeadingZeroes(searchTextCapital)
            if self.SegmentedPNOrAssembly.selectedSegmentIndex == 0 {
                self.dataArray = CSVPNFiles.sheredInstance.searchInFile(searchTextNoLeadingZero, csv: self.csv)
            }else if self.SegmentedPNOrAssembly.selectedSegmentIndex == 1 {
                
            }
            self.tableView!.reloadData()
            self.ActivityIndicator.stopAnimating()
            self.ActivityIndicator.hidden = true
            
            
        }

        /*
        // Start a new one download
        dispatch_async(dispatch_get_main_queue()) {
            print("\(searchText)")
            
            let searchTextCapital = searchText.uppercaseString
            let searchTextNoLeadingZero = self.trimLeadingZeroes(searchTextCapital)
            if self.SegmentedPNOrAssembly.selectedSegmentIndex == 0 {
            self.dataArray = CSVPNFiles.sheredInstance.testFile(searchTextNoLeadingZero )
            }else if self.SegmentedPNOrAssembly.selectedSegmentIndex == 1 {
                
            }
            self.tableView!.reloadData()
            self.ActivityIndicator.stopAnimating()
            self.ActivityIndicator.hidden = true
            
            
        }
        */
    }
    
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    // MARK: - Table View Delegate and Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataFound = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId , forIndexPath: indexPath)
        
        configureCell(cell, data: dataFound)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    //expand and contract the cell view method part 1: define a place o hold the index
    var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
    // transfer the data found to the next view controller search in BOM file
    var tempDataPicked = Data()
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToBOM" {
            let vc : BOMViewController = segue.destinationViewController as! BOMViewController
            vc.ItemPassed = tempDataPicked
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataPicked = dataArray[indexPath.row]
        // if the press is the second one
        if  indexPath.row == selectedRowIndex.row {
            tempDataPicked = dataPicked
            self.performSegueWithIdentifier("segueToBOM", sender: nil);
        }
        //expand and contract the cell view method part 2: hold the index , enable editing
        
        selectedRowIndex = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // self.dismissViewControllerAnimated(true, completion: nil)
    }
    //expand and contract the cell view method part 3 : toogle shrink and expand
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        //check if the index actually exists
        
        if  indexPath.row == selectedRowIndex.row {
            return 120
        }
        return 44
        
        
    }
    
    //  tableView(_:accessoryButtonTappedForRowWithIndexPath:)
    
    
    // cell data all in one place , expands the number of text lines to grow with the cell
    func configureCell(cell: UITableViewCell, data: Data) {
        cell.layer.cornerRadius = cell.frame.width / 12
        cell.clipsToBounds = true
        cell.textLabel!.text = data.itemDescription
        cell.textLabel!.numberOfLines = 0;
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    func presentError(alertString: String){
       // self.ActivityIndicator.stopAnimating()
        let ac = UIAlertController(title: "Error", message: alertString, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    func trimLeadingZeroes(input: String) -> String {
        var result = ""
        for character in input.characters {
            if result.isEmpty && character == "0" { continue }
            result.append(character)
        }
        return result
    }

    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    /*   func processAndAppendSampleData ()
    {
    let itemsData = hardCodedItemsData()
    for dictionary in itemsData {
    let ItemDescription = dictionary["ItemDescription"] as! String
    let tempData = Data()
    tempData.itemDescription = ItemDescription
    dataArray.append(tempData)
    }
    } */
    
    /* func hardCodedItemsData() -> [[String : AnyObject]] {
    return  [[ "ItemDescription" : "Jessica-Plasson" ],["ItemDescription" : "Gabrielle- mines."],["ItemDescription" : "Libi-Plasson mines."]]
    }*/
    
}

