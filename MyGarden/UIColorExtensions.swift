//
//  UIColorExtensions.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 26.05.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

extension UIColor {
    static func candyGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    }
    static func candyGreenWithoutOpacity() -> UIColor {
        return UIColor(red: 94.0/255.0, green: 211.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    }

    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    // Creates a UIColor from a Hex string.
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

        if cString.hasPrefix("#") {
            cString = (cString as NSString).substringFromIndex(1)
        }

        if cString.characters.count != 6 {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)

            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)

            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
    }
}
