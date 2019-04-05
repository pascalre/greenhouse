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
        // Swift 2: var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }

        if cString.characters.count != 6 {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substring(to: 2)
            let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
            let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)

            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)

            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
    }
}
