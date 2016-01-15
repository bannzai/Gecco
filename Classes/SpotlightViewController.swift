//
//  SpotlightViewController.swift
//  Spot
//
//  Created by Asai.Yuki on 2016/01/15.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation
import UIKit

public class SpotlightViewController: UIViewController {
    
    private var maskLayer = CAShapeLayer()
    private var transitioning = false
    
    public var presentTransitionType = SpotlightTransitionType.Infinitesimal
    public var dismissTransitionType = SpotlightTransitionType.Infinity
    public var spotlight: Spotlight?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        modalPresentationStyle = .OverCurrentContext
        transitioningDelegate = self
        
        createOverlayView()
        createSpotlight()
    }
    
    private func createOverlayView() {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(view)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
            ])
    }
    
    private func createSpotlight() {
        maskLayer.frame = view.frame
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = UIColor.blackColor().CGColor
        view.layer.mask = maskLayer
    }
    
    private var infinityPath: UIBezierPath {
        return [spotlight].flatMap { $0 }.reduce(UIBezierPath(rect: view.frame)) {
            let width = CGFloat(2000)
            let center = CGPointMake($1.frame.midX, $1.frame.midY)
            let size = CGSizeMake(width, width)
            let scaledRect = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height)
            $0.appendPath(UIBezierPath(ovalInRect: scaledRect))
            return $0
        }
    }
    
    private var infinitesmalPath: UIBezierPath {
        return [spotlight].flatMap { $0 }.reduce(UIBezierPath(rect: view.frame)) {
            $0.appendPath(UIBezierPath(ovalInRect: CGRect(origin: $1.center, size: CGSizeZero)))
            return $0
        }
    }
    
    private var spotlightPath: UIBezierPath {
        return [spotlight].flatMap { $0 }.reduce(UIBezierPath(rect: view.frame)) {
            $0.appendPath(UIBezierPath(ovalInRect: $1.frame))
            return $0
        }
    }
    
    private func animateSpotlight(duration: NSTimeInterval, path: UIBezierPath) {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0, 0.33, 1)
        animation.toValue = path.CGPath
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        maskLayer.addAnimation(animation, forKey: "anim")
    }
    
    public func showSpotlight(duration: NSTimeInterval) {
        maskLayer.path = infinitesmalPath.CGPath
        animateSpotlight(duration, path: spotlightPath)
    }
    
    public func hideSpotlight(duration: NSTimeInterval) {
    }
}

extension SpotlightViewController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension SpotlightViewController: UIViewControllerAnimatedTransitioning {
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
            animations: { destination.view.alpha = 1.0 },
            completion: nil
        )
        showSpotlight(transitionDuration(transitionContext))
    }
    
    public func animationEnded(transitionCompleted: Bool) {
    }
}

public struct Spotlight {
    var center: CGPoint
    var width: CGFloat
    
    var frame: CGRect {
        return CGRectMake(center.x - width / 2, center.y - width / 2, width, width)
    }
}
