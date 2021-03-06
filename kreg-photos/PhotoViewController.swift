//
//  PhotoViewController.swift
//
//  Created by Kreg Holgerson on 10/4/15.
//  Copyright © 2015 Kreg Holgerson. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var itemIndex: Int = 0
    var photo: Photo!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text! = photo.name
        if let url = NSURL(string: photo.image_url) {
            if let data = NSData(contentsOfURL: url){
                imageView.image = UIImage(data: data)
            }
        }
    }
  
}
