//
//  PhotoListViewPresenter.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/20.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

protocol PhotoListViewPresenter {
    var photoInfoList: [PhotoInfo] { get }
    func setup(viewController: PhotoListViewPresenterOutput)
    func viewDidLoad()
}

protocol PhotoListViewPresenterOutput: AnyObject {
    func updatePhotoList()
}

final class PhotoListViewPresenterImpl: PhotoListViewPresenter {

    weak var viewController: PhotoListViewPresenterOutput?
    var photoInfoList = [PhotoInfo]()
    let photoInfoRepository: PhotoInfoRepository

    init(photoInfoRepository: PhotoInfoRepository) {
        self.photoInfoRepository = photoInfoRepository
    }

    func setup(viewController: PhotoListViewPresenterOutput) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        photoInfoRepository.getYesterdayInterestingPhotos(page: 1) { [unowned self] (result) in
            switch result {
            case .success(let photos):
                let group = DispatchGroup()
                let queue = DispatchQueue(label: "queue", attributes: .concurrent)
                photos.photo.forEach { (photo) in
                    group.enter()
                    queue.async(group: group, execute: DispatchWorkItem(block: {
                        self.photoInfoRepository.getPhotoSize(by: photo.id) { (result) in
                            switch result {
                            case .success(let photoSize):
                                if !photoSize.sizes.size.isEmpty {
                                    let targetSize = photoSize.sizes.size.filter { $0.label == "Medium"}
                                        .first ?? photoSize.sizes.size.last!
                                    let photoInfo = PhotoInfo(id: photo.id,
                                                              title: photo.title,
                                                              source: targetSize.source,
                                                              width: targetSize.width,
                                                              height: targetSize.height)
                                    self.photoInfoList.append(photoInfo)
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            group.leave()
                        }
                    }))
                }

                group.notify(queue: .main) {
                    self.viewController?.updatePhotoList()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
