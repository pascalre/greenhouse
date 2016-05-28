//
//  CalendarView.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 15.05.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    var plant: Plant? {
        didSet {
            print("jööp")
        }
    }

    /*{
        didSet {
            self.layoutIfNeeded()
            let bounds = self.bounds.width
            let x: Int = Int(bounds/11)

            let cons = ([
                "Januar": 5,
                "Februar": x*1,
                "März": x*2,
                "April": x*3,
                "Mai": x*4,
                "Juni": x*5,
                "Juli": x*6,
                "August": x*7,
                "September": x*8,
                "Oktober": x*9,
                "November": x*10,
                "Dezember": x*11-5,
                "": 0])
            let fromX = cons[plant!.vorkulturAb!]!
            let untilX = cons[plant!.vorkulturBis!]!

            UIColor.greenColor().setFill()
            let rect = CGRectMake(CGFloat(fromX), CGFloat(7+0*8), CGFloat(untilX-fromX), CGFloat(6))
            print("test")
        }
    }*/
}
