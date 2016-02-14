//
//  BOMViewController.swift
//  PLASCAT
//
//  Created by Lauren Efron on 01/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

let CellReuseIdBOM = "bomCell"

class BOMViewController: UIViewController , UITableViewDataSource ,UITableViewDelegate  {

    static let sheredInstance = BOMViewController()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let CSVOfBOM = SearchViewController.sheredInstance.csvBOM
       ItemBOM = CSVBOMFiles.sheredInstance.searchInFileForAssembly(ItemPassed.ItemNumber, csv: CSVOfBOM )
        tableView?.reloadData()
    }
    
    
    @IBOutlet weak var PartLabel: UILabel!
    
    // The data for the table.
    var ItemPassed : Data!
    
    var ItemBOM = [Data]()

    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataFound = ItemBOM[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdBOM , forIndexPath: indexPath) as! bomTableViewCell
        cell.accessoryType = .DetailDisclosureButton
        
       // cell.shareButton.tag = indexPath.row;
       // cell.shareButton.addTarget(self, action: "logAction:", forControlEvents: .TouchUpInside)
        configureCell(cell, data: dataFound)
        
        return cell
    }
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
       
        let titleString = ItemBOM[indexPath.row].itemDescription
        
        let firstActivityItem = "\(titleString)"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemBOM.count
    }
    
    //expand and contract the cell view method part 1: define a place o hold the index
    var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //expand and contract the cell view method part 2: hold the index , enable editing
        
        selectedRowIndex = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    //expand and contract the cell view method part 3 : toogle shrink and expand
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        //check if the index actually exists
        
        if  indexPath.row == selectedRowIndex.row {
            return 160
        }
        return 44
    }
    
    
    // cell data all in one place , expands the number of text lines to grow with the cell
    func configureCell(cell: UITableViewCell, data: Data) {
        cell.layer.cornerRadius = cell.frame.width / 12
        cell.clipsToBounds = true
        cell.textLabel!.text = data.itemDescription
        
        // expend the number of text lines to fit the larger screen
        cell.textLabel!.numberOfLines = 0;
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    

}
