//
//  Photo.swift
//
//  Created by Kreg Holgerson on 10/1/15.
//  Copyright © 2015 Kreg Holgerson. All rights reserved.
//

import Foundation

class Photo {
    var name: String = ""
    var image_url: String = ""
    var user: User = User()
    
    func printSomeDetails() {
        print(name)
        print("   " + user.firstname + " " + user.lastname)
    }
}