//
//  PhotoInfoEntity.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/21.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

struct PhotoInfoEntity: Decodable {
    let photos: Photos
}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [Photo]
}

struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
}
