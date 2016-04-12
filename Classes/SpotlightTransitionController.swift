//
//  SpotlightTransitionController.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/19.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

protocol SpotlightTransitionControllerDelegate: class {
    func spotlightTransitionWillPresent(controller: SpotlightTransitionController, transitionContext: UIViewControllerContextTransitioning)
    func spotlightTransitionWillDismiss(controller: SpotlightTransitionController, transitionContext: UIViewControllerContextTransitioning)
}

class SpotlightTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresent = false
    
    weak var delegate: SpotlightTransitionControllerDelegate?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animateTransitionForPresent(transitionContext)
        } else {
            animateTransitionForDismiss(transitionContext)
        }
    }
    
    private func animateTransitionForPresent(transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let destination = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                fatalError()
        }
        transitionContext.containerView()?.insertSubview(destination.view, aboveSubview: source.view)
        
        destination.view.alpha = 0
        
        source.viewWillDisappear(true)
        destination.viewWillAppear(true)
        
        let duration = transitionDuration(transitionContext)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }
        { // In transation
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
                animations: {
                    destination.view.alpha = 1.0
                },
                completion: { _ in
                    destination.viewDidAppear(true)
                    source.viewDidDisappear(true)
                }
            )
            delegate?.spotlightTransitionWillPresent(self, transitionContext: transitionContext)
        }()
        CATransaction.commit()
    }
    
    private func animateTransitionForDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let destination = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                fatalError()
        }
        
        source.viewWillDisappear(true)
        destination.viewWillAppear(true)
        
        let duration = transitionDuration(transitionContext)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }
        { // In transation
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
                animations: {
                    source.view.alpha = 0.0
                },
                completion: { _ in
                    destination.viewDidAppear(true)
                    source.viewDidDisappear(true)
                }
            )
            delegate?.spotlightTransitionWillDismiss(self, transitionContext: transitionContext)
        }()
        CATransaction.commit()
    }
    
    func animationEnded(transitionCompleted: Bool) {
    }
}
