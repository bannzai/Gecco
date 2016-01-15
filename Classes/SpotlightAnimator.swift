//
//  SpotlightAnimator.swift
//  Spot
//
//  Created by Asai.Yuki on 2016/01/15.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public class SpotlightAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let destination = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                fatalError()
        }
        
        transitionContext.containerView()?.insertSubview(destination.view, aboveSubview: source.view)
        
        destination.view.alpha = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut,
            animations: {
                destination.view.alpha = 1.0
            },
            completion: nil
        )
    }
    
    public func animationEnded(transitionCompleted: Bool) {
    }
}
