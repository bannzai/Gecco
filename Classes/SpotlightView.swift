//
//  SpotlightView.swift
//  Spot
//
//  Created by asai.yuki on 2016/01/16.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class SpotlightView: UIView {
    
    var spotlight = Spotlight(center: CGPointZero, width: 100)
    
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
    private var infinityPath: UIBezierPath {
        return [spotlight].reduce(UIBezierPath(rect: frame)) {
            let width = CGFloat(2000)
            let center = CGPointMake($1.frame.midX, $1.frame.midY)
            let size = CGSizeMake(width, width)
            let scaledRect = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height)
            $0.appendPath(UIBezierPath(ovalInRect: scaledRect))
            return $0
        }
    }
    
    private var infinitesmalPath: UIBezierPath {
        return [spotlight].reduce(UIBezierPath(rect: frame)) {
            $0.appendPath(UIBezierPath(ovalInRect: CGRect(origin: $1.center, size: CGSizeZero)))
            return $0
        }
    }
    
    private var spotlightPath: UIBezierPath {
        return [spotlight].reduce(UIBezierPath(rect: frame)) {
            $0.appendPath(UIBezierPath(ovalInRect: $1.frame))
            return $0
        }
    }
}