//
//  DetailViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var plantImageView: UIImageView!
    
    var detailPlant: Plant? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if isViewLoaded() {
            let name = (detailPlant!.valueForKey("name") as? String)!
            plantImageView.image = UIImage(named: name)
            title = name
            print(name)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}