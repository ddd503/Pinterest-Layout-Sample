//
//  PhotoDetailInfoCell.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/15.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoDetailInfoCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoTitleLabel: UILabel!
    @IBOutlet private weak var photoIdLabel: UILabel!

    func setInfo(_ info: PhotoInfo) {
        photoImageView.load(url: info.source, placeholder: nil)
        photoTitleLabel.text = info.title
        photoIdLabel.text = "ID: \(info.id)"
        photoTitleLabel.isHidden = info.title.isEmpty
        photoIdLabel.isHidden = info.id.isEmpty
    }
}
