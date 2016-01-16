//
//  SpotlightView.swift
//  Spot
//
//  Created by asai.yuki on 2016/01/16.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class SpotlightView: UIView {
    var spotlight = Spotlight.Oval(center: CGPointZero, width: 100)
    
    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor.blackColor().CGColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = frame
    }
    
    func showSpotlight(duration: NSTimeInterval) {
        maskLayer.path = infinitesmalPath.CGPath
        animateSpotlight(duration, path: spotlightPath)
    }
    
    func hideSpotlight(duration: NSTimeInterval) {
        animateSpotlight(duration, path: infinitesmalPath)
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
}

extension SpotlightView {
    private var infinitesmalPath: UIBezierPath {
        return [spotlight].reduce(UIBezierPath(rect: frame)) {
            $0.appendPath($1.path)
            return $0
        }
    }
    
    private var spotlightPath: UIBezierPath {
        return [spotlight].reduce(UIBezierPath(rect: frame)) {
            $0.appendPath($1.path)
            return $0
        }
    }
}