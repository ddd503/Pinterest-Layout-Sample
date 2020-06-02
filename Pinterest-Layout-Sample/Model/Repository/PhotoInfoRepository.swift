//
//  PhotoInfoRepository.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/21.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation
import Keys

enum APIRequestError: Error {
    case invalidRequest
}

protocol PhotoInfoRepository {
    func getYesterdayInterestingPhotos(page: Int, completion: @escaping (Result<Photos, Error>) -> ())
    func getPhotoSize(by id: String, completion: @escaping (Result<PhotoSizeEntity, Error>) -> ())
}

final class PhotoInfoRepositoryImpl: PhotoInfoRepository {

    private let flickrAPIBaseURL = URL(string: "https://api.flickr.com/services/rest/")!
    let apiDataStore: APIDataStore

    init(apiDataStore: APIDataStore) {
        self.apiDataStore = apiDataStore
    }

    func getYesterdayInterestingPhotos(page: Int, completion: @escaping (Result<Photos, Error>) -> ()) {
        let params = ["api_key": PinterestLayoutSampleKeys().api_key,
                      "method": "flickr.interestingness.getList",
                      "date": "2020-05-29",
                      "per_page": "100",
                      "page": "\(page)",
                      "format": "json",
                      "nojsoncallback": "1"]

        guard let request = flickrAPIBaseURL.getRequest(params: params) else {
            completion(.failure(APIRequestError.invalidRequest))
            return
        }

        apiDataStore.connection(requet: request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let photoInfoEntity = try JSONDecoder().decode(PhotoInfoEntity.self, from: data)
                    completion(.success(photoInfoEntity.photos))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPhotoSize(by id: String, completion: @escaping (Result<PhotoSizeEntity, Error>) -> ()) {
        let params = ["api_key": PinterestLayoutSampleKeys().api_key,
                      "method": "flickr.photos.getSizes",
                      "photo_id": id,
                      "format": "json",
                      "nojsoncallback": "1"]

        guard let request = flickrAPIBaseURL.getRequest(params: params) else {
            completion(.failure(APIRequestError.invalidRequest))
            return
        }

        apiDataStore.connection(requet: request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let photoSizeEntity = try JSONDecoder().decode(PhotoSizeEntity.self, from: data)
                    completion(.success(photoSizeEntity))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
