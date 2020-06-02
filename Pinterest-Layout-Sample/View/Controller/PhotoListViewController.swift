//
//  PhotoListViewController.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/20.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoListViewController: UIViewController {

    @IBOutlet weak private var photoListView: UICollectionView! {
        didSet {
            photoListView.dataSource = self
            photoListView.delegate = self
            photoListView.register(PhotoInfoCell.nib(),
                                   forCellWithReuseIdentifier: PhotoInfoCell.identifier)
        }
    }

    private let presenter: PhotoListViewPresenter

    init(presenter: PhotoListViewPresenter) {
        self.presenter = presenter
        super.init(nibName: "PhotoListViewController", bundle: .main)
        presenter.setup(viewController: self)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photoInfoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoInfoCell.identifier, for: indexPath) as! PhotoInfoCell
        cell.setInfo(presenter.photoInfoList[indexPath.item])
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegate {}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? PhotoListViewLayout else {
            return .zero
        }
        let width = layout.contentWidth / CGFloat(layout.numberOfColumns)
        let photoInfo = presenter.photoInfoList[indexPath.item]
        let ratio = width / CGFloat(photoInfo.width)
        let height = CGFloat(photoInfo.height) * ratio
        return CGSize(width: width, height: height)
    }
}

extension PhotoListViewController: PhotoListViewPresenterOutput {
    func updatePhotoList() {
        DispatchQueue.main.async { [unowned self] in
            self.photoListView.reloadData()
        }
    }
}
