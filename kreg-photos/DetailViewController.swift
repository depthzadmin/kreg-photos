//
//  DetailViewController.swift
//
//  Created by Kreg Holgerson on 9/30/15.
//  Copyright © 2015 Kreg Holgerson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let aPhoto = detail as! Photo
                label.text = ""
                if let url = NSURL(string: aPhoto.image_url) {
                    if let data = NSData(contentsOfURL: url){
                        imageView.image = UIImage(data: data)
                    }
                }

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

