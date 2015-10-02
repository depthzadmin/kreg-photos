//
//  MasterViewController.swift
//
//  Created by Kreg Holgerson on 9/30/15.
//  Copyright © 2015 Kreg Holgerson. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var dataProvider: DataProvider = DataProvider()
    var objectsSearchResults = [AnyObject]()
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        objects = dataProvider.getPhotos()
        objectsSearchResults = objects
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objectsSearchResults[indexPath.row] as! Photo
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return objectsSearchResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell

        //let object = objects[indexPath.row] as! Photo
        let object = objectsSearchResults[indexPath.row] as! Photo

        cell.titleLabel.text = object.name
        cell.bringSubviewToFront(cell.titleLabel)
        cell.userLabel.text = "by " + object.user.firstname + " " + object.user.lastname
    
        if let url = NSURL(string: object.image_url) {
            if let data = NSData(contentsOfURL: url){
                cell.photoImage.image = UIImage(data: data)
            }
        }
        if let url = NSURL(string: object.user.userpic_url) {
            if let data = NSData(contentsOfURL: url){
                let anImage = UIImage(data: data)
                cell.userImage.image = anImage
                cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
                cell.userImage.clipsToBounds = true
            }
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    func filterContentForSearchText(searchText: String) {
        objectsSearchResults = objects.filter({(anObject) -> Bool in
            let aPhoto = anObject as! Photo
            return aPhoto.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
        if (objectsSearchResults.count == 0) && (searchBar.text == "") {
            objectsSearchResults = objects
        }
        tableView.reloadData()
    }

}

