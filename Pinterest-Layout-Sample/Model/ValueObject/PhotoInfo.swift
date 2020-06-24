//
//  PhotoInfo.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/01.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation
import UIKit

struct PhotoInfo {
    let id: String
    let title: String
    let source: URL
    let width: Int
    let height: Int
    var cacheImage: UIImage?
}
