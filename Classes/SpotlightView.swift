//
//  SpotlightView.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/16.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

public class SpotlightView: UIView {
    public static let defaultAnimateDuration: NSTimeInterval = 0.25
    
    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor.blackColor().CGColor
        return layer
    }()
    
    var spotlights: [SpotlightType]!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.mask = maskLayer
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = frame
    }
    
    public func appear(spotlight: SpotlightType, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.addAnimation(appearAnimation(duration, spotlights: [spotlight]), forKey: nil)
        self.spotlights = [spotlight]
    }
    
    public func appear(spotlights: [SpotlightType], duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        guard spotlights.count > 0 else { return }
        maskLayer.addAnimation(appearAnimation(duration, spotlights: spotlights), forKey: nil)
        self.spotlights = spotlights
    }
    
    public func disappear(duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.addAnimation(disappearAnimation(duration), forKey: nil)
    }
    
    public func move(toSpotlight: SpotlightType, duration: NSTimeInterval = SpotlightView.defaultAnimateDuration, moveType: SpotlightMoveType = .Direct) {
        switch moveType {
        case .Direct:
            moveDirect([toSpotlight], duration: duration)
        case .Disappear:
            moveDisappear([toSpotlight], duration: duration)
        }
    }
    
    public func move(toSpotlights: [SpotlightType], duration: NSTimeInterval = SpotlightView.defaultAnimateDuration, moveType: SpotlightMoveType = .Direct) {
        switch moveType {
        case .Direct:
            moveDirect(toSpotlights, duration: duration)
        case .Disappear:
            moveDisappear(toSpotlights, duration: duration)
        }
    }
}

extension SpotlightView {
    private func moveDirect(toSpotlights: [SpotlightType], duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.addAnimation(moveAnimation(duration, toSpotlights: toSpotlights), forKey: nil)
        spotlights = toSpotlights
    }
    
    private func moveDisappear(toSpotlights: [SpotlightType], duration: NSTimeInterval = SpotlightView.defaultAnimateDuration) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.appear(toSpotlights, duration: duration)
            self.spotlights = toSpotlights
        }
        disappear(duration)
        CATransaction.commit()
    }
    
    private func maskPaths(paths: [UIBezierPath]) -> UIBezierPath {
        return paths.reduce(UIBezierPath(rect: frame)) {
            $0.appendPath($1)
            return $0
        }
    }
    
    private func appearAnimation(duration: NSTimeInterval, spotlights: [SpotlightType]) -> CAAnimation {
        let beginPath = maskPaths([spotlights.first!.infinitesmalPath])
        let endPaths = spotlights.map { $0.path }
        let endPath = maskPaths(endPaths)
        return pathAnimation(duration, beginPath:beginPath, endPath: endPath)
    }

    private func disappearAnimation(duration: NSTimeInterval) -> CAAnimation {
        let endPath = maskPaths([spotlights!.first!.infinitesmalPath])
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }
    
    private func moveAnimation(duration: NSTimeInterval, toSpotlights: [SpotlightType]) -> CAAnimation {
        let endPaths = toSpotlights.map { $0.path }
        let endPath = maskPaths(endPaths)
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
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