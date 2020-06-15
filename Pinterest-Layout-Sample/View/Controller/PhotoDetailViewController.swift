//
//  PhotoDetailViewController.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var photoDetailInfoList: UICollectionView! {
        didSet {
            photoDetailInfoList.dataSource = self
            photoDetailInfoList.delegate = self
            photoDetailInfoList.register(PhotoDetailInfoCell.nib(),
                                   forCellWithReuseIdentifier: PhotoDetailInfoCell.identifier)
        }
    }
    private let photoInfo: PhotoInfo

    init(photoInfo: PhotoInfo) {
        self.photoInfo = photoInfo
        super.init(nibName: "PhotoDetailViewController", bundle: .main)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailInfoCell.identifier, for: indexPath) as! PhotoDetailInfoCell
        cell.setInfo(photoInfo)
        return cell
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? PhotoDetailInfoListViewLayout else {
            return .zero
        }
        let width = layout.contentWidth / CGFloat(layout.numberOfColumns)
        let ratio = width / CGFloat(photoInfo.width)
        let ceilValue = ceil(ratio * 100) / 100
        let height = CGFloat(photoInfo.height) * ceilValue + 60 // 妥協の暫定対応（StackViewの高さが計算できない）
        return CGSize(width: width, height: height)
    }
}
