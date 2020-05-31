//
//  PhotoListTransitter.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/31.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoListTransitter {
    static func makePhotoListViewController() -> PhotoListViewController {
        let apiDataStore = APIDataStoreImpl()
        let photoInfoRepository = PhotoInfoRepositoryImpl(apiDataStore: apiDataStore)
        let presenter = PhotoListViewPresenterImpl(photoInfoRepository: photoInfoRepository)
        return PhotoListViewController(presenter: presenter)
    }
}
