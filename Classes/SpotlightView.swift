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
    
    var spotlights: [SpotlightType] = []
    
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
        self.spotlights = [spotlight]
    }
   
    open func appear(_ spotlights: [SpotlightType], duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.add(appearAnimation(duration, spotlights: spotlights), forKey: nil)
        self.spotlights = spotlights
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
        spotlights = [toSpotlight]
    }
    
    fileprivate func moveDisappear(_ toSpotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.appear(toSpotlight, duration: duration)
            self.spotlights = [toSpotlight]
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
    
    fileprivate func appearAnimation(_ duration: TimeInterval, spotlights: [SpotlightType]) -> CAAnimation {
        var combinedPath = UIBezierPath(rect: frame)
        var animations:[CAAnimation] = []
        
        spotlights.forEach { spotlight in
            var beginPath = UIBezierPath(cgPath: combinedPath.cgPath)
            var endPath = UIBezierPath(cgPath: combinedPath.cgPath)
            
            beginPath.append(spotlight.infinitesmalPath)
            endPath.append(spotlight.path)
            
            animations.append(pathAnimation(duration, beginTime: duration * TimeInterval(animations.count), beginPath: beginPath, endPath: endPath))
            
            combinedPath = endPath
        }
        
        return animationGroup(duration: duration, animations: animations)
    }
    
    fileprivate func disappearAnimation(_ duration: TimeInterval) -> CAAnimation {
        var animations:[CAAnimation] = []
        var spotlights = self.spotlights
        
        while !spotlights.isEmpty {
            let hideMe = spotlights.removeLast()
            
            let path = spotlights.reduce(UIBezierPath(rect: frame)) {
                $0.append($1.path)
                return $0
            }
            
            path.append(hideMe.infinitesmalPath)
            
            animations.append(pathAnimation(duration, beginTime: duration * TimeInterval(animations.count), beginPath: nil, endPath: path))
        }
        
        return animationGroup(duration: duration, animations: animations)
    }
    
    fileprivate func moveAnimation(_ duration: TimeInterval, toSpotlight: SpotlightType) -> CAAnimation {
        let endPath = maskPath(toSpotlight.path)
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }
    
    fileprivate func animationGroup(duration:TimeInterval , animations: [CAAnimation]) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        animationGroup.isRemovedOnCompletion = false
        animationGroup.duration = duration * Double(animations.count)
        animationGroup.fillMode = kCAFillModeForwards
        
        return animationGroup
    }
    
    fileprivate func pathAnimation(_ duration: TimeInterval, beginTime: TimeInterval = 0, beginPath: UIBezierPath?, endPath: UIBezierPath) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0, 0.33, 1)
        if let path = beginPath {
            animation.fromValue = path.cgPath
        }
        animation.toValue = endPath.cgPath
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.beginTime = beginTime
        return animation
    }
}

public enum SpotlightMoveType {
    case direct
    case disappear
}
