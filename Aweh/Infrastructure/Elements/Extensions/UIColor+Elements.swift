//
//  UIColor+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/08.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIColor {
    static var randomPalate: UIColor {
        UIColor(hue: CGFloat.random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
    
    static func random(from text: String) -> UIColor {
        let textHash = text.hash % 200
        srand48(textHash * 200)
        let r = CGFloat(drand48())
        srand48(textHash)
        let g = CGFloat(drand48())
        srand48(textHash / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    static func randomPalate(from text: String) -> UIColor {
        let textHash = text.hash % 100
        let hue = CGFloat(textHash / 100)
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
    }

    //    public Color generateRandomColor(Color mix) {
    //        Random random = new Random();
    //        int red = random.nextInt(256);
    //        int green = random.nextInt(256);
    //        int blue = random.nextInt(256);
    //
    //        // mix the color
    //        if (mix != null) {
    //            red = (red + mix.getRed()) / 2;
    //            green = (green + mix.getGreen()) / 2;
    //            blue = (blue + mix.getBlue()) / 2;
    //        }
    //
    //        Color color = new Color(red, green, blue);
    //        return color;
    //    }
}
