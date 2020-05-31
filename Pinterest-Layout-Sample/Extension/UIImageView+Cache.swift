//
//  UIImageView+Cache.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/31.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared // カスタムのキャッシュ管理クラスを渡していない場合デフォルトのsharedを使用
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data,
            let image = UIImage(data: data) {
            // キャッシュがある場合は使う
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data,
                    let response = response,
                    ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300,
                    let image = UIImage(data: data) {
                    // キャッシュがない場合はダウンロードして、キャッシュ、表示
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async { [unowned self] in
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
