//
//  SpotlightView.swift
//  Gecco
//
//  Created by asai.yuki on 2016/01/16.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public class SpotlightView: UIView {
    public static let defaultAnimateDuration: NSTimeInterval = 0.25
    
    var spotlight = Spotlight.Oval(center: CGPointZero, width: 100)
    
    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor.blackColor().CGColor
        return layer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.mask = maskLayer
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.mask = maskLayer
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = frame
    }
    
    public func appear(spotlight: Spotlight? = nil, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        let light = spotlight ?? self.spotlight
        maskLayer.addAnimation(appearAnimation(duration, spotlight: light), forKey: nil)
    }
    
    public func disappear(spotlight: Spotlight? = nil, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.addAnimation(disappearAnimation(duration, spotlight: spotlight), forKey: nil)
    }
   
    public func move(toSpotlight: Spotlight, fromSpotlight: Spotlight? = nil, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration, moveType: SpotlightMoveType = .Direct) {
        switch moveType {
        case .Direct:
            moveDirect(toSpotlight, fromSpotlight: fromSpotlight, duration: duration)
        case .Disappear:
            moveDisappear(toSpotlight, fromSpotlight: fromSpotlight, duration: duration)
        }
    }
}

extension SpotlightView {
    private func moveDirect(toSpotlight: Spotlight, fromSpotlight: Spotlight? = nil, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.addAnimation(moveAnimation(duration, fromSpotlight: fromSpotlight, toSpotlight: toSpotlight), forKey: nil)
        spotlight = toSpotlight
    }
    
    private func moveDisappear(toSpotlight: Spotlight, fromSpotlight: Spotlight? = nil, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.appear(toSpotlight, duration: duration)
            self.spotlight = toSpotlight
        }
        disappear(fromSpotlight, duration: duration)
        CATransaction.commit()
    }
    
    private func maskPath(path: UIBezierPath) -> UIBezierPath {
        return [path].reduce(UIBezierPath(rect: frame)) {
            $0.appendPath($1)
            return $0
        }
    }
    
    private func appearAnimation(duration: NSTimeInterval, spotlight: Spotlight) -> CAAnimation {
        let beginPath = maskPath(spotlight.infinitesmalPath)
        let endPath = maskPath(spotlight.path)
        return pathAnimation(duration, beginPath:beginPath, endPath: endPath)
    }
    
    private func disappearAnimation(duration: NSTimeInterval, spotlight: Spotlight?) -> CAAnimation {
        let light = spotlight ?? self.spotlight
        let endPath = maskPath(light.infinitesmalPath)
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }
    
    private func moveAnimation(duration: NSTimeInterval, fromSpotlight: Spotlight?, toSpotlight: Spotlight) -> CAAnimation {
        let beginPath = { () -> UIBezierPath? in
            guard let path = fromSpotlight else { return nil }
            return self.maskPath(path.path)
        }()
        let endPath = maskPath(toSpotlight.path)
        return pathAnimation(duration, beginPath:beginPath, endPath: endPath)
    }
    
    private func pathAnimation(duration: NSTimeInterval, beginPath: UIBezierPath?, endPath: UIBezierPath) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0, 0.33, 1)
        if let path = beginPath {
            animation.fromValue = path.CGPath
        }
        animation.toValue = endPath.CGPath
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
}

public enum SpotlightMoveType {
    case Direct
    case Disappear
}