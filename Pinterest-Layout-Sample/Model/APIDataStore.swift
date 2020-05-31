//
//  APIDataStore.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/21.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

enum APIError: Error {
    case clientError(Error)
    case serverError(HTTPURLResponse)
    case noResponse
}

protocol APIDataStore {
    func connection(requet: URLRequest, completion: @escaping (Result<Data, Error>) -> ())
}

final class APIDataStoreImpl: APIDataStore {
    func connection(requet: URLRequest, completion: @escaping (Result<Data, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: requet) { (data, response, error) in
            if let error = error {
                // アプリ側のエラー（クライアントエラー、ホストに接続できなかったなど）
                print(error.localizedDescription)
                completion(.failure(APIError.clientError(error)))
                return
            }

            // レスポンスがない（dataは返却データ、responseは通信結果情報）
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                completion(.failure(APIError.noResponse))
                return
            }

            if response.statusCode == 200 {
                completion(.success(data))
            } else {
                // レスポンスのステータスコードが200でない場合などはサーバサイドのエラー
                completion(.failure(APIError.serverError(response)))
            }
        }
        // 実行
        task.resume()
    }
}
