//
//  SpotlightViewController.swift
//  Spot
//
//  Created by Asai.Yuki on 2016/01/15.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation
import UIKit

public protocol SpotlightViewControllerDelegate: class {
    func spotlightViewControllerTapped(viewController: SpotlightViewController)
}

public class SpotlightViewController: UIViewController {
    
    public var delegate: SpotlightViewControllerDelegate?
    
    private var isPresent = false
    
    lazy var spotlightView: SpotlightView = {
        let view = SpotlightView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.userInteractionEnabled = false
        self.view.addSubview(view)
        self.view.addConstraints([NSLayoutAttribute.Top, .Bottom, .Left, .Right].map {
            NSLayoutConstraint(item: self.view, attribute: $0, relatedBy: .Equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
            })
        return view
    }()
    
    public var spotlight: Spotlight {
        get { return spotlightView.spotlight }
        set { spotlightView.spotlight = newValue }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        modalPresentationStyle = .OverCurrentContext
        transitioningDelegate = self
        
        setupTapGesture()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: "viewTapped:");
        view.addGestureRecognizer(gesture)
    }
}

extension SpotlightViewController {
    func viewTapped(gesture: UITapGestureRecognizer) {
        delegate?.spotlightViewControllerTapped(self)
    }
}

extension SpotlightViewController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension SpotlightViewController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
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
            spotlightView.appear(duration)
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
            spotlightView.disappear(duration)
        }()
        CATransaction.commit()
    }
    
    public func animationEnded(transitionCompleted: Bool) {
    }
}

