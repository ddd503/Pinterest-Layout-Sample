//
//  PhotoListViewLayout.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/05/31.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class PhotoListViewLayout: UICollectionViewFlowLayout {

    weak var delegate: UICollectionViewDelegateFlowLayout?
    private var attributesArray = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    let numberOfColumns = 2

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView,
            let delegateFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let cellWidth = contentWidth / CGFloat(numberOfColumns)
        let cellXOffsets = (0 ..< numberOfColumns).map {
            CGFloat($0) * cellWidth
        }
        var cellYOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
        var currentColumnNumber = 0
        let section = 0
        (0..<collectionView.numberOfItems(inSection: section)).forEach {
            let indexPath = IndexPath(item: $0, section: section)
            guard let cellSize = delegateFlowLayout.collectionView?(collectionView,
                                                                    layout: self,
                                                                    sizeForItemAt: indexPath) else {
                                                                        return
            }
            let origin = CGPoint(x: cellXOffsets[currentColumnNumber],
                                 y: cellYOffsets[currentColumnNumber])
            let cellFrame = CGRect(origin: origin, size: cellSize)
            cellYOffsets[currentColumnNumber] = cellYOffsets[currentColumnNumber] + cellSize.height
            currentColumnNumber = currentColumnNumber < (numberOfColumns - 1) ? currentColumnNumber + 1 : 0
            // セル毎にスペースを入れる
            let itemFrame = cellFrame.insetBy(dx: 7, dy: 10)
            // Attributesを追加
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = itemFrame
            attributesArray.append(attributes)
            // ContentSizeを更新
            contentHeight = max(contentHeight, cellFrame.maxY)
        }
    }

    override var collectionViewContentSize: CGSize {
        // prepareが終わった後に呼ばれるので、計算したcontentHeightを返す
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // 生成したUICollectionViewLayoutAttributesを返す（要素数→セルの数）
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray.filter({ (layoutAttributes) -> Bool in
            rect.intersects(layoutAttributes.frame)
        })
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesArray[indexPath.item]
    }
}
