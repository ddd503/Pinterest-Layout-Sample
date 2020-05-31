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
        presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoInfoCell.identifier, for: indexPath) as! PhotoInfoCell
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegate {}

extension PhotoListViewController: PhotoListViewPresenterOutput {
    func updatePhotoList() {
        DispatchQueue.main.async { [unowned self] in
            self.photoListView.reloadData()
        }
    }
}
