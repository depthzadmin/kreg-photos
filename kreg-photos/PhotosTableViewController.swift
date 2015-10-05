//
//  PhotosTableViewController.swift
//
//  Created by Kreg Holgerson on 10/4/15.
//  Copyright © 2015 Kreg Holgerson. All rights reserved.
//

import Foundation
import UIKit

class PhotosTableViewController : UITableViewController, UIPageViewControllerDataSource, UISearchBarDelegate  {
    
    private var pageViewController: UIPageViewController!
    var dataProvider: DataProvider = DataProvider()
    //var photos: [String]?
    var photos = [AnyObject]()
    var objectsSearchResults = [AnyObject]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPhotos()
        setupPageControl()
        //objects = dataProvider.getPhotos()
        objectsSearchResults = photos
    }
    
    func loadPhotos() {
        //photos = ["1", "2", "3", "4", "5"]
        //photos = ["AA", "BA", "CC", "DD"]
        photos = dataProvider.getPhotos()
    }
    
    // MARK: - UITableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return photos!.count
        return objectsSearchResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        //cell.textLabel!.text = photos![indexPath.row] as String
        //cell.textLabel!.text = objectsSearchResults[indexPath.row] as? String
        let aPhoto = objectsSearchResults[indexPath.row] as! Photo
        cell.titleLabel.text = aPhoto.name
        //cell.bringSubviewToFront(cell.titleLabel)
        cell.userLabel.text = "by " + aPhoto.user.firstname + " " + aPhoto.user.lastname
        
        if let url = NSURL(string: aPhoto.image_url) {
            if let data = NSData(contentsOfURL: url){
                cell.photoImage.image = UIImage(data: data)
            }
        }
        if let url = NSURL(string: aPhoto.user.userpic_url) {
            if let data = NSData(contentsOfURL: url){
                let anImage = UIImage(data: data)
                cell.userImage.image = anImage
                cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
                cell.userImage.clipsToBounds = true
            }
        }
        
        return cell
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {        
        if segue.identifier == "showPageViewController" {
            //let object = objectsSearchResults[indexPath.row] as! Photo
            let controller = (segue.destinationViewController as! UIPageViewController)
            controller.dataSource = self
            let pageController = photoViewAtIndex((tableView.indexPathForSelectedRow!.row) + 1)
            let viewControllers = [pageController]
            controller.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        }
    }
    
    // MARK: - UIPageViewController
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
        
    }

    func photoViewAtIndex(index: Int) -> PhotoViewController {
        let photoController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoController") as! PhotoViewController
        photoController.itemIndex = index
        let aPhoto = objectsSearchResults[index-1] as! Photo
        photoController.photo = aPhoto
        return photoController
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
 
        let photoController = viewController as! PhotoViewController
        if photoController.itemIndex-1 > 0 {
            return photoViewAtIndex(photoController.itemIndex-1)
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let photoController = viewController as! PhotoViewController
        if photoController.itemIndex < objectsSearchResults.count {
            return photoViewAtIndex(photoController.itemIndex+1)
        }
        return nil
    }

    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return objectsSearchResults.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return (tableView.indexPathForSelectedRow!.row)
    }
    
    // MARK: - Search Bar
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(searchText: String) {
        objectsSearchResults = photos.filter({(anObject) -> Bool in
            let aPhoto = anObject as! Photo
            return aPhoto.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
        if (objectsSearchResults.count == 0) && (searchBar.text == "") {
            objectsSearchResults = photos
        }

//        objectsSearchResults = objects.filter({(anObject) -> Bool in
//            let aPhoto = anObject as! Photo
//            return aPhoto.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
//        })
//        if (objectsSearchResults.count == 0) && (searchBar.text == "") {
//            objectsSearchResults = objects
//        }
        tableView.reloadData()
    }


    
}
