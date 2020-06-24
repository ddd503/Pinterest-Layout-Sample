//
//  PresentTransitionAnimator.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/14.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

enum PresentTransitionAnimationStyle {
    case zoomUpPhoto(info: PhotoInfo)
}

protocol ZoomUpPhotoTransitionFromControllerType: UIViewController {
    var photoListView: UICollectionView! { get }
}

protocol ZoomUpPhotoTransitionFromViewType: UIView {
    var photoImageView: UIImageView! { get }
}

protocol ZoomUpPhotoTransitionToControllerType: UIViewController {
    var photoInfoListView: UICollectionView! { get }
}

protocol ZoomUpPhotoTransitionToViewType: UIView {
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
        case .zoomUpPhoto(let photoInfo):
            zoomUpPhotoTransition(transitionContext: transitionContext, photoInfo: photoInfo)
        }
    }

    private func zoomUpPhotoTransition(transitionContext: UIViewControllerContextTransitioning, photoInfo: PhotoInfo) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ZoomUpPhotoTransitionFromControllerType,
            let selectedPhotoIndexPath = fromVC.photoListView.indexPathsForSelectedItems?.first,
            let fromView = fromVC.photoListView.cellForItem(at: selectedPhotoIndexPath) as? ZoomUpPhotoTransitionFromViewType,
            let toVC = transitionContext.viewController(forKey: .to) as? ZoomUpPhotoTransitionToControllerType else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        toVC.view.frame = UIScreen.main.bounds
        toVC.view.layoutIfNeeded()
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)

        guard let toView = toVC.photoInfoListView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ZoomUpPhotoTransitionToViewType else {
                transitionContext.completeTransition(false)
                return
        }

        toView.photoImageView.alpha = 0

        let dummyImageViewFrame = fromView.convert(fromView.photoImageView.frame, to: fromVC.view)
        let dummyImageView = UIImageView(frame: dummyImageViewFrame)
        dummyImageView.image = toView.photoImageView.image ?? fromView.photoImageView.image
        dummyImageView.contentMode = toView.photoImageView.contentMode
        containerView.addSubview(dummyImageView)
        dummyImageView.layer.masksToBounds = true
        dummyImageView.layer.cornerRadius = 15
        dummyImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let dummyImageBackgroundView = UIView(frame: dummyImageViewFrame)
        dummyImageBackgroundView.backgroundColor = fromVC.photoListView.backgroundColor
        // 背景をtoVC.viewの後ろに差し込む
        containerView.insertSubview(dummyImageBackgroundView, belowSubview: toVC.view)

        let distinationFrame = toView.convert(toView.photoImageView.frame, to: toVC.view)

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.8) {
            dummyImageView.frame = distinationFrame
            toVC.view.alpha = 1.0
        }

        animator.addCompletion { (_) in
            toView.photoImageView.alpha = 1.0
            dummyImageView.removeFromSuperview()
            dummyImageBackgroundView.removeFromSuperview()
            let isFinishTransition = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isFinishTransition)
        }

        animator.startAnimation()
    }
}
