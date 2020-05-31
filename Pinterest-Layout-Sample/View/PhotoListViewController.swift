//
//  PhotoListViewController.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/20.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit
import Keys

final class PhotoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://api.flickr.com/services/rest/")!
        let request = url
            .getRequest(params: ["api_key": PinterestLayoutSampleKeys().api_key,
                                 "method": "flickr.interestingness.getList",
                                 "date": "2020-05-29",
                                 "extras": "url_o,date_taken",
                                 "per_page": "3",
                                 "page": "1",
                                 "format": "json",
                                 "nojsoncallback": "1"])!
        print(request.url?.absoluteString as Any)
        APIDataStoreImpl().connection(requet: request) { (result) in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8) as Any)
                do {
                    let ddd = try JSONDecoder().decode(PhotoInfoEntity.self, from: data)
                    print(ddd)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
