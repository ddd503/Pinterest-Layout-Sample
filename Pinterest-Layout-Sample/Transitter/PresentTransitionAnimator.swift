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
            let dummyPhotoImageView = fromView.photoImageView.snapshotView(afterScreenUpdates: true),
            let toVC = transitionContext.viewController(forKey: .to) as? ZoomUpPhotoTransitionToControllerType else {
                return
        }

        let containerView = transitionContext.containerView
//        let finalFrame = transitionContext.finalFrame(for: toVC)
        let width = toVC.photoImageView.frame.width
        let ratio = width / CGFloat(photoInfo.width)
        let ceilValue = ceil(ratio * 100) / 100
        let height = CGFloat(photoInfo.height) * ceilValue
        toVC.photoImageView.frame.size.height = height

        toVC.view.layoutIfNeeded()
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)

        let dummyPhotoImageFrame = fromVC.view.convert(fromView.frame, to: fromVC.photoListView)
        dummyPhotoImageView.frame = dummyPhotoImageFrame
        containerView.addSubview(dummyPhotoImageView)

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.5) {
            dummyPhotoImageView.frame = toVC.photoImageView.frame
        }

        animator.addCompletion { (_) in
            dummyPhotoImageView.removeFromSuperview()
            toVC.view.alpha = 1.0
            let isFinishTransition = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isFinishTransition)
        }

        animator.startAnimation()
    }
}
