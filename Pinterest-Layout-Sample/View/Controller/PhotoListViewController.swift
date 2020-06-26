//
//  PhotoListViewController.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/20.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoListViewController: UIViewController, ZoomUpPhotoTransitionDepartureControllerType {

    @IBOutlet weak var photoListView: UICollectionView! {
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
        nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var didSelectPhotoInfo = presenter.photoInfoList[indexPath.item]
        if let didSelectCell = collectionView.cellForItem(at: indexPath) as? PhotoInfoCell {
            didSelectPhotoInfo.cacheImage = didSelectCell.displayImage()
        }
        let photoDetailVC = AppTransitter.makePhotoDetailViewController(photoInfo: didSelectPhotoInfo)
        photoDetailVC.transitioningDelegate = self
        photoDetailVC.modalPresentationStyle = .fullScreen
        present(photoDetailVC, animated: true)
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? PhotoListViewLayout else {
            return .zero
        }
        let width = layout.contentWidth / CGFloat(layout.numberOfColumns)
        let photoInfo = presenter.photoInfoList[indexPath.item]
        let ratio = width / CGFloat(photoInfo.width)
        let ceilValue = ceil(ratio * 100) / 100
        let height = CGFloat(photoInfo.height) * ceilValue
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

extension PhotoListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PresentTransitionAnimator(duration: 0.7, style: .zoomUpPhoto)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissTransitionAnimator(duration: 0.3, style: .zoomOutPhoto)
    }
}
