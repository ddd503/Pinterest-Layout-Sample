//
//  PhotoDetailViewController.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

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

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

        let dummyTitleLabel = UILabel(frame: .zero)
        dummyTitleLabel.frame.size.width = width
        dummyTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        dummyTitleLabel.text = photoInfo.title
        dummyTitleLabel.sizeToFit()
        let dummyIdLabel = UILabel(frame: .zero)
        dummyIdLabel.frame.size.width = width
        dummyIdLabel.font = UIFont.systemFont(ofSize: 12)
        dummyIdLabel.text = photoInfo.id
        dummyIdLabel.sizeToFit()
        let allSpacing = CGFloat(25)
        let infoContentHeight = dummyTitleLabel.frame.height + dummyIdLabel.frame.height + allSpacing // StackView分(妥協の暫定対応)

        let height = CGFloat(photoInfo.height) * ceilValue + infoContentHeight

        return CGSize(width: width, height: height)
    }
}
