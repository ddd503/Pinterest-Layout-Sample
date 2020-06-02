//
//  PhotoSizeEntity.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/01.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

struct PhotoSizeEntity: Decodable {
    let sizes: Sizes
}

struct Sizes: Decodable {
    let size: [Size]
}

struct Size: Decodable {
    let label: String
    let width: Int
    let height: Int
    let source: String
}
