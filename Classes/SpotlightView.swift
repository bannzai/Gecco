//
//  SpotlightView.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/16.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

open class SpotlightView: UIView {
    open static let defaultAnimateDuration: TimeInterval = 0.25
    
    fileprivate lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor.black.cgColor
        return layer
    }()
    
    var spotlight: SpotlightType?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        layer.mask = maskLayer
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = frame
    }
    
    open func appear(_ spotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.add(appearAnimation(duration, spotlight: spotlight), forKey: nil)
        self.spotlight = spotlight
    }
    
    open func disappear(_ duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.add(disappearAnimation(duration), forKey: nil)
    }
   
    open func move(_ toSpotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration, moveType: SpotlightMoveType = .direct) {
        switch moveType {
        case .direct:
            moveDirect(toSpotlight, duration: duration)
        case .disappear:
            moveDisappear(toSpotlight, duration: duration)
        }
    }
}

extension SpotlightView {
    fileprivate func moveDirect(_ toSpotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.add(moveAnimation(duration, toSpotlight: toSpotlight), forKey: nil)
        spotlight = toSpotlight
    }
    
    fileprivate func moveDisappear(_ toSpotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.appear(toSpotlight, duration: duration)
            self.spotlight = toSpotlight
        }
        disappear(duration)
        CATransaction.commit()
    }
    
    fileprivate func maskPath(_ path: UIBezierPath) -> UIBezierPath {
        return [path].reduce(UIBezierPath(rect: frame)) {
            $0.append($1)
            return $0
        }
    }
    
    fileprivate func appearAnimation(_ duration: TimeInterval, spotlight: SpotlightType) -> CAAnimation {
        let beginPath = maskPath(spotlight.infinitesmalPath)
        let endPath = maskPath(spotlight.path)
        return pathAnimation(duration, beginPath:beginPath, endPath: endPath)
    }
    
    fileprivate func disappearAnimation(_ duration: TimeInterval) -> CAAnimation {
        let endPath = maskPath(spotlight!.infinitesmalPath)
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }
    
    fileprivate func moveAnimation(_ duration: TimeInterval, toSpotlight: SpotlightType) -> CAAnimation {
        let endPath = maskPath(toSpotlight.path)
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }
    
    fileprivate func pathAnimation(_ duration: TimeInterval, beginPath: UIBezierPath?, endPath: UIBezierPath) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0, 0.33, 1)
        if let path = beginPath {
            animation.fromValue = path.cgPath
        }
        animation.toValue = endPath.cgPath
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
}

public enum SpotlightMoveType {
    case direct
    case disappear
}
