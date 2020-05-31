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
    case invalidURL
    case invalidRequest
}

protocol PhotoInfoRepository {
    func readYesterdayInterestingPhotos(page: Int, completion: @escaping (Result<Photos, Error>) -> ())
}

final class PhotoInfoRepositoryImpl: PhotoInfoRepository {

    let apiDataStore: APIDataStore

    init(apiDataStore: APIDataStore) {
        self.apiDataStore = apiDataStore
    }

    func readYesterdayInterestingPhotos(page: Int, completion: @escaping (Result<Photos, Error>) -> ()) {
        guard let url = URL(string: "https://api.flickr.com/services/rest/") else {
            completion(.failure(APIRequestError.invalidURL))
            return
        }

        let params = ["api_key": PinterestLayoutSampleKeys().api_key,
                      "method": "flickr.interestingness.getList",
                      "date": "2020-05-29",
                      "extras": "url_o,date_taken",
                      "per_page": "3",
                      "page": "\(page)",
                      "format": "json",
                      "nojsoncallback": "1"]

        guard let request = url.getRequest(params: params) else {
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
}
