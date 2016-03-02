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
//open the files get ready for search
let firstTimeAppUsed = Bool()
let csvBOM = CSVBOMFiles.sheredInstance.openBOMFile()
let csvLUL = CSVPNFiles.sheredInstance.openLULFile()

class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    static let sheredInstance = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checks if data exists if so work with it , else download
        if NSUserDefaults.standardUserDefaults().boolForKey("DataExists") {

        //calling the files to be loaded to memory  for faster search later
        print(csvBOM.columnCount)
        print(csvLUL.columnCount)
        }else {
            downlaodProgressBar().downloadFiles()
        }
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.becomeFirstResponder()
        
    }
  
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var SegmentedPNOrAssembly: UISegmentedControl!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch SegmentedPNOrAssembly.selectedSegmentIndex
        {
        case 0:
            searchBar.placeholder = "Search Catalog By Catalog Number"
        case 1:
            searchBar.placeholder = "Search Catalog By BOM"
            
        default:
            break;
        }
    }
    
    // The data for the table.
    var dataArray = [Data]()
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let data = searchBar.text!
        let charectersToSkip = 0
        SearchTheData(data , charectersToSkip: charectersToSkip)
    }
    
    // MARK: - Search Bar Delegate
    
    // Each time the search text changes we want to cancel any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let charectersToSkip = 6
        SearchTheData(searchText , charectersToSkip: charectersToSkip)
        
    }
    
    func SearchTheData (searchText : String , charectersToSkip : Int){
        // Cancel the last task
        
        // If the text is empty we are done
        if searchText == "" {
            dataArray = [Data]()
            tableView?.reloadData()
            objc_sync_exit(self)
            return
        }
        
        // Start a new search
        dispatch_async(dispatch_get_main_queue()) {
            
            let searchTextCapital = searchText.uppercaseString
            let searchTextNoLeadingZero = self.trimLeadingZeroes(searchTextCapital)
            //search for prts in the small table
            if self.SegmentedPNOrAssembly.selectedSegmentIndex == 0 {
                self.dataArray = CSVPNFiles.sheredInstance.searchInFile(searchTextNoLeadingZero, csv: csvLUL , charectersToSkip : charectersToSkip)
                // search for BOM in the large table
            }else if self.SegmentedPNOrAssembly.selectedSegmentIndex == 1 {
                self.dataArray = CSVBOMFiles.sheredInstance.searchInFile(searchTextNoLeadingZero, csv: csvBOM  , charectersToSkip : charectersToSkip)
            }
            self.tableView!.reloadData()
            // let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            // self.tableView.selectRowAtIndexPath(firstIndexPath, animated: true, scrollPosition: .Top )
        }
        
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
    
    // transfer the data found to the next view controller search in BOM file
    var tempDataPicked = Data()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToBOM" {
            let vc : BOMViewController = segue.destinationViewController as! BOMViewController
            vc.ItemPassed = tempDataPicked
            
        }
    }
    //expand and contract the cell view method part 1: define a place to hold the index
    var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
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
        
    }
    //expand and contract the cell view method part 3 : toogle shrink and expand
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        //check if the index actually exists
        
        if  indexPath.row == selectedRowIndex.row {
            return 180
        }
        return 44
        
        
    }
    
    
    
    // cell data all in one place , expands the number of text lines to grow with the cell
    func configureCell(cell: UITableViewCell, data: Data) {
        cell.layer.cornerRadius = cell.frame.width / 12
        cell.clipsToBounds = true
        cell.textLabel!.text = data.itemDescription
        cell.textLabel!.numberOfLines = 0;
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
    }
    
    override func presentError(alertString: String){
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

