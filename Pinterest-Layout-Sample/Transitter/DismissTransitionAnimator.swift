//
//  DismissTransitionAnimator.swift
//  Pinterest-Layout-Sample
//
//  Created by kawaharadai on 2020/06/27.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

enum DismissTransitionAnimationStyle {
    case zoomOutPhoto
}

final class DismissTransitionAnimator: NSObject {
    let duration: TimeInterval
    let style: DismissTransitionAnimationStyle

    init(duration: TimeInterval, style: DismissTransitionAnimationStyle) {
        self.duration = duration
        self.style = style
    }
}

extension DismissTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch style {
        case .zoomOutPhoto:
            zoomOutPhotoTransition(transitionContext: transitionContext)
        }
    }

    private func zoomOutPhotoTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let transitionFromVC = transitionContext.viewController(forKey: .from) as? ZoomUpPhotoTransitionArrivalControllerType,
            let transitionFromView = transitionFromVC.photoInfoListView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ZoomUpPhotoTransitionArrivalViewType,
            let transitionToVC = transitionContext.viewController(forKey: .to) as? ZoomUpPhotoTransitionDepartureControllerType,
            let selectedPhotoIndexPath = transitionToVC.photoListView.indexPathsForSelectedItems?.first,
            let transitionToView = transitionToVC.photoListView.cellForItem(at: selectedPhotoIndexPath) as? ZoomUpPhotoTransitionDepartureViewType else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        containerView.insertSubview(transitionToVC.view, at: 0)

        let dummyImageViewFrame = transitionFromView.convert(transitionFromView.photoImageView.frame, to: transitionFromVC.view)
        let dummyImageView = UIImageView(frame: dummyImageViewFrame)
        dummyImageView.image = transitionFromView.photoImageView.image
        dummyImageView.contentMode = transitionFromView.photoImageView.contentMode
        containerView.addSubview(dummyImageView)
        dummyImageView.layer.masksToBounds = true
        dummyImageView.layer.cornerRadius = 15
        containerView.addSubview(dummyImageView)

        let distinationFrame = transitionToView.convert(transitionToView.photoImageView.frame, to: transitionToVC.view)

        let dummyTransitionToViewImageBackgroundView = UIView(frame: distinationFrame)
        dummyTransitionToViewImageBackgroundView.backgroundColor = transitionToVC.photoListView.backgroundColor
        containerView.insertSubview(dummyTransitionToViewImageBackgroundView, belowSubview: transitionFromVC.view)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            dummyImageView.frame = distinationFrame
            transitionFromVC.view.alpha = 0
        }

        animator.addCompletion { (_) in
            dummyTransitionToViewImageBackgroundView.removeFromSuperview()
            dummyImageView.removeFromSuperview()
            let isFinishTransition = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isFinishTransition)
        }

        animator.startAnimation()
    }
}
