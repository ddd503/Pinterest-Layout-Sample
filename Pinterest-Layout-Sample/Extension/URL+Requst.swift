//
//  URL+Requst.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/30.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

extension URL {
    func getRequest(params: [String: String]? = nil) -> URLRequest? {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return nil
        }
        if let params = params {
            let queryItems = params.keys.compactMap { (key) -> URLQueryItem? in
                guard let value = params[key] else {
                    return nil
                }
                return URLQueryItem(name: key, value: value)
            }
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    func postRequest(params: [String: Any]) -> URLRequest? {
        var request = URLRequest(url: self)
        request.httpMethod = "POST"
        if !params.isEmpty {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else {
                return nil
            }
            request.httpBody = httpBody
        }
        return request
    }
}
