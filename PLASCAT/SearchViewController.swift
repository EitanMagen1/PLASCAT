//
//  SearchViewController.swift
//  PLASCAT
//
//  Created by Lauren Efron on 28/01/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate {
    func dataPicker(dataPicker: SearchViewController, didFindData data: Data?)
}

class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    static let sheredInstance = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processAndAppendSampleData ()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.becomeFirstResponder()
    }
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    
    // The data for the table.
    var dataArray = [Data]()
    
    var delegate: SearchViewControllerDelegate?
    var searchTask: NSURLSessionDataTask?
    
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        self.delegate?.dataPicker(self, didFindData: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Search Bar Delegate
    
    // Each time the search text changes we want to cancel any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If the text is empty we are done
        if searchText == "" {
            dataArray = [Data]()
            tableView?.reloadData()
            //objc_sync_exit(self)
            return
        }
        
        // Start a new one download
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView!.reloadData()
        }
    }
    
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

    }
    // MARK: - Table View Delegate and Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellReuseId = "SearchCell"
        let dataFound = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId)!
        
        configureCell(cell, data: dataFound)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataPicked = dataArray[indexPath.row]
        // Alert the delegate
        delegate?.dataPicker(self, didFindData: dataPicked)
        selectedRowIndex = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        print("taped")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        //check if the index actually exists
        
        if  indexPath.row == selectedRowIndex.row {
            return 100
        }
        return 44
    }

    
    // All right, this is kind of meager. But its nice to be consistent
    func configureCell(cell: UITableViewCell, data: Data) {
        cell.textLabel!.text = data.itemDescription
    }
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    func processAndAppendSampleData ()
    {
        let itemsData = hardCodedItemsData()
        for dictionary in itemsData {
            let ItemDescription = dictionary["ItemDescription"] as! String
            let tempData = Data()
            tempData.itemDescription = ItemDescription
            dataArray.append(tempData)
        }
    }
    
    func hardCodedItemsData() -> [[String : AnyObject]] {
        return  [[ "ItemDescription" : "Jessica-Plasson Industries Ltd. is a global manufacturer of plastic fittings for plastic pipes used in water distribution systems, gas conveyance systems, industrial fluid transfer and wastewater systems, and mines." ],["ItemDescription" : "Gabrielle-Plasson Industries Ltd. is a global manufacturer of plastic fittings for plastic pipes used in water distribution systems, gas conveyance systems, industrial fluid transfer and wastewater systems, and mines."]]
    }
    
}

