//
//  PresentTransitionAnimator.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

enum PresentTransitionAnimationStyle {
    case zoomUpPhoto
}

protocol ZoomUpPhotoTransitionDepartureControllerType: UIViewController {
    var photoListView: UICollectionView! { get }
}

protocol ZoomUpPhotoTransitionDepartureViewType: UIView {
    var photoImageView: UIImageView! { get }
}

protocol ZoomUpPhotoTransitionArrivalControllerType: UIViewController {
    var photoInfoListView: UICollectionView! { get }
}

protocol ZoomUpPhotoTransitionArrivalViewType: UIView {
    var photoImageView: UIImageView! { get }
}

final class PresentTransitionAnimator: NSObject {
    let duration: TimeInterval
    let style: PresentTransitionAnimationStyle

    init(duration: TimeInterval, style: PresentTransitionAnimationStyle) {
        self.duration = duration
        self.style = style
    }
}

extension PresentTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch style {
        case .zoomUpPhoto:
            zoomUpPhotoTransition(transitionContext: transitionContext)
        }
    }

    private func zoomUpPhotoTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let transitionFromVC = transitionContext.viewController(forKey: .from) as? ZoomUpPhotoTransitionDepartureControllerType,
            let selectedPhotoIndexPath = transitionFromVC.photoListView.indexPathsForSelectedItems?.first,
            let transitionFromView = transitionFromVC.photoListView.cellForItem(at: selectedPhotoIndexPath) as? ZoomUpPhotoTransitionDepartureViewType,
            let transitionToVC = transitionContext.viewController(forKey: .to) as? ZoomUpPhotoTransitionArrivalControllerType else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        transitionToVC.view.frame = UIScreen.main.bounds
        transitionToVC.view.layoutIfNeeded()
        transitionToVC.view.alpha = 0
        containerView.addSubview(transitionToVC.view)

        guard let transitionToView = transitionToVC.photoInfoListView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ZoomUpPhotoTransitionArrivalViewType else {
                transitionContext.completeTransition(false)
                return
        }

        transitionToView.photoImageView.alpha = 0

        let dummyImageViewFrame = transitionFromView.convert(transitionFromView.photoImageView.frame, to: transitionFromVC.view)
        let dummyImageView = UIImageView(frame: dummyImageViewFrame)
        dummyImageView.image = transitionToView.photoImageView.image ?? transitionFromView.photoImageView.image
        dummyImageView.contentMode = transitionToView.photoImageView.contentMode
        containerView.addSubview(dummyImageView)
        dummyImageView.layer.masksToBounds = true
        dummyImageView.layer.cornerRadius = 15
        dummyImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let dummyImageBackgroundView = UIView(frame: dummyImageViewFrame)
        dummyImageBackgroundView.backgroundColor = transitionFromVC.photoListView.backgroundColor
        // 背景をtoVC.viewの後ろに差し込む
        containerView.insertSubview(dummyImageBackgroundView, belowSubview: transitionToVC.view)

        let distinationFrame = transitionToView.convert(transitionToView.photoImageView.frame, to: transitionToVC.view)

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.8) {
            dummyImageView.frame = distinationFrame
            transitionToVC.view.alpha = 1.0
        }

        animator.addCompletion { (_) in
            transitionToView.photoImageView.alpha = 1.0
            dummyImageView.removeFromSuperview()
            dummyImageBackgroundView.removeFromSuperview()
            let isFinishTransition = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isFinishTransition)
        }

        animator.startAnimation()
    }
}
