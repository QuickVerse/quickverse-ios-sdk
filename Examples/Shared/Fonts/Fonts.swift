//
//  Fonts.swift
//  Examples
//
//  Created by QuickVerse on 05/05/2023.
//

import UIKit

struct Fonts {
    
    private static let lexendLight = "Lexend-Light"
    private static let lexendRegular = "Lexend-Regular"
    private static let lexendMedium = "Lexend-Medium"
    private static let lexendSemiBold = "Lexend-SemiBold"
    
    static func lexendLight(size: CGFloat) -> UIFont {
        return UIFont(name: lexendLight, size: size)!
    }
    static func lexendRegular(size: CGFloat) -> UIFont {
        return UIFont(name: lexendRegular, size: size)!
    }
    static func lexendMedium(size: CGFloat) -> UIFont {
        return UIFont(name: lexendMedium, size: size)!
    }
    static func lexendSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: lexendSemiBold, size: size)!
    }
}
