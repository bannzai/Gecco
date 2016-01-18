//
//  SpotlightView.swift
//  Spot
//
//  Created by asai.yuki on 2016/01/16.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class SpotlightView: UIView {
    var spotlight = Spotlight.Oval(center: CGPointZero, width: 100) {
        didSet {
            move(0, fromSpotlight: oldValue, toSpotlight: spotlight)
        }
    }
    
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
        layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = frame
    }
    
    func appear(duration: NSTimeInterval, spotlight: Spotlight? = nil) {
        let light = spotlight ?? self.spotlight
        maskLayer.addAnimation(appearAnimation(duration, spotlight: light), forKey: nil)
    }
    
    func disappear(duration: NSTimeInterval, spotlight: Spotlight? = nil) {
        maskLayer.addAnimation(disappearAnimation(duration, spotlight: spotlight), forKey: nil)
    }
   
    func move(duration: NSTimeInterval, fromSpotlight: Spotlight?, toSpotlight: Spotlight, moveType: SpotlightMoveType = .Direct) {
        switch moveType {
        case .Direct:
            moveDirect(duration, fromSpotlight: fromSpotlight, toSpotlight: toSpotlight)
        case .Disapper:
            moveDisappear(duration, fromSpotlight: fromSpotlight, toSpotlight: toSpotlight)
        }
    }
}

extension SpotlightView {
    private func moveDirect(duration: NSTimeInterval, fromSpotlight: Spotlight?, toSpotlight: Spotlight) {
        maskLayer.addAnimation(moveAnimation(duration, fromSpotlight: fromSpotlight, toSpotlight: toSpotlight), forKey: nil)
    }
    
    private func moveDisappear(duration: NSTimeInterval, fromSpotlight: Spotlight?, toSpotlight: Spotlight) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.appear(duration, spotlight: toSpotlight)
        }
        disappear(duration, spotlight: fromSpotlight)
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
    case Disapper
}