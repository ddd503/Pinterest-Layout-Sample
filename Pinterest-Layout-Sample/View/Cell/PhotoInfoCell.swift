//
//  PhotoInfoCell.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/31.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoInfoCell: UICollectionViewCell, ZoomUpPhotoTransitionFromViewType {

    @IBOutlet weak var photoImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    func setInfo(_ info: PhotoInfo) {
        photoImageView.load(url: info.source, placeholder: nil)
    }
}
