//
//  CalendarView.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 25.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class CalendarView: UIView {

    // MARK: Initialisierung
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.text = "Basilikum"
        titleLabel.sizeToFit()

        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRectMake(0, 19, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = UIColor.blackColor()
        subtitleLabel.font = UIFont.systemFontOfSize(11)
        subtitleLabel.text = "Genoveser"
        subtitleLabel.sizeToFit()

        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRectMake(16, 6, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        addSubview(titleView)
        
    }

    func makeHeader() -> UIView {
        let titleView = UIView(frame: CGRectMake(0, 0, 30, 30))
        let x = 10
        for i in 1 ..< 13 {
            let titleLabel = UILabel(frame: CGRectMake(CGFloat(x*i), 0, 0, 0)) //x, y, width, height where y is to offset from the view center
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.textColor = UIColor.blackColor()
            titleLabel.font = UIFont.systemFontOfSize(16)
            titleLabel.text = "J"
            titleLabel.sizeToFit()
            titleView.addSubview(titleLabel)
        }
        return titleView
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.5, 0.5, 0.5, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 30, 40)
        CGContextAddLineToPoint(context, 300, 40)
        CGContextStrokePath(context)
    }
}
