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
            configureView()
        }
    }
    
    func configureView() {
        if let detailPlant = detailPlant {
            if let plantImageView = plantImageView {
                let name = (detailPlant.valueForKey("name") as? String)!
                plantImageView.image = UIImage(named: name)
                title = name
                print(name)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}