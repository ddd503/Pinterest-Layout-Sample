//
//  PhotoInfoCell.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/31.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoInfoCell: UICollectionViewCell {

    @IBOutlet weak private var photoImageView: UIImageView!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    func setInfo(_ info: PhotoInfo) {
        let imageUrlString = info.url_o ?? "https://farm\(info.farm).staticflickr.com/\(info.server)/\(info.id)_\(info.secret).jpg"
        if let imageUrl = URL(string: imageUrlString) {
            photoImageView.load(url: imageUrl, placeholder: nil)
        }
    }
}
