//
//  DataProvider.swift
//
//  Created by Kreg Holgerson on 10/1/15.
//  Copyright © 2015 Kreg Holgerson. All rights reserved.
//

import Foundation

class DataProvider {
    
    var photos = [AnyObject]()
    
    func getPhotos() -> [AnyObject] {
        parseJSON()
        return photos
    }
    
    func getURL() -> NSURL? {
        let reposURL = NSURL(string: "https://api.500px.com/v1/photos?feature=popular&consumer_key=vW8Ns53y0F57vkbHeDfe3EsYFCatTJ3BrFlhgV3W")
        return reposURL
    }
    func parseJSON(){
        let reposURL = getURL()
        guard let JSONData = NSData(contentsOfURL: reposURL!) else { return }
        do {
            guard let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary else { return }
            guard let reposArray = json["photos"] as? [NSDictionary] else { return }
            for item in reposArray {
                guard
                    let name = item["name"] as? String,
                    let image_url = item["image_url"] as? String,
                    let user = item["user"] as? NSDictionary,
                    let firstname = user["firstname"] as? String,
                    let lastname = user["lastname"] as? String,
                    let userpic_url = user["userpic_url"] as? String
                    else {
                        print("bad input")
                        return
                }
                
                let aPhoto = Photo()
                aPhoto.name = name
                aPhoto.image_url = image_url
                aPhoto.user.firstname = firstname
                aPhoto.user.lastname = lastname
                aPhoto.user.userpic_url = userpic_url
                aPhoto.printSomeDetails()
                photos.append(aPhoto)
                //aPhoto.printSomeDetails()
            }
        }
        catch let error as NSError {
            // Catch fires here, with an NSError being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }

    }
}