//
//  PhotoListViewPresenter.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/20.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

protocol PhotoListViewPresenter {
    var photos: [PhotoInfo] { get }
    func setup(viewController: PhotoListViewPresenterOutput)
    func viewDidLoad()
}

protocol PhotoListViewPresenterOutput: AnyObject {
    func updatePhotoList()
}

final class PhotoListViewPresenterImpl: PhotoListViewPresenter {

    weak var viewController: PhotoListViewPresenterOutput?
    var photos = [PhotoInfo]()
    let photoInfoRepository: PhotoInfoRepository

    init(photoInfoRepository: PhotoInfoRepository) {
        self.photoInfoRepository = photoInfoRepository
    }

    func setup(viewController: PhotoListViewPresenterOutput) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        photoInfoRepository.readYesterdayInterestingPhotos(page: 1) { [unowned self] (result) in
            switch result {
            case .success(let photos):
                self.photos = photos.photo
                self.viewController?.updatePhotoList()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
