//
//  PhotoDetailViewController.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

    init() {
        super.init(nibName: "PhotoDetailViewController", bundle: .main)
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    @IBOutlet weak private var infoListView: UICollectionView! {
        didSet {
            infoListView.dataSource = self
            infoListView.register(PhotoDetailInfoCell.nib(),
                                  forCellWithReuseIdentifier: PhotoDetailInfoCell.identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailInfoCell.identifier, for: indexPath) as! PhotoDetailInfoCell
        return cell
    }
}
