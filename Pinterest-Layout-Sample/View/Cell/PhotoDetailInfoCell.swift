//
//  PhotoDetailInfoCell.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoDetailInfoCell: UICollectionViewCell {

    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var photoTitleLabel: UILabel!
    @IBOutlet weak private var photoIdLabel: UILabel!

    func setInfo(_ info: PhotoInfo) {}
}
