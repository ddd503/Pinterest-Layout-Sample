//
//  UIView+XIB.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
