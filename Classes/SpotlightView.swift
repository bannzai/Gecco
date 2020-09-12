//
//  SpotlightView.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/16.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

public protocol SpotlightViewDelegate: AnyObject {
    func spotlightWillAppear(spotlightView: SpotlightView, spotlight: SpotlightType)
    func spotlightDidAppear(spotlightView: SpotlightView, spotlight: SpotlightType)
    func spotlightWillDisappear(spotlightView: SpotlightView, spotlight: SpotlightType)
    func spotlightDidDisappear(spotlightView: SpotlightView, spotlight: SpotlightType)
    func spotlightWillMove(spotlightView: SpotlightView, spotlight: SpotlightType, moveType: SpotlightMoveType)
    func spotlightDidMove(spotlightView: SpotlightView, spotlight: SpotlightType, moveType: SpotlightMoveType)
}

open class SpotlightView: UIView {
    public static let defaultAnimateDuration: TimeInterval = 0.25

    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        layer.fillColor = UIColor.black.cgColor
        return layer
    }()
    
    internal var spotlights: [SpotlightType] = []
    public weak var delegate: SpotlightViewDelegate?

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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = frame
    }
    
    open func appear(_ spotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        appear([spotlight], duration: duration)
    }
    
    open func appear(_ spotlights: [SpotlightType], duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.add(appearAnimation(duration, spotlights: spotlights), forKey: nil)
        self.spotlights.append(contentsOf: spotlights)
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
    private func moveDirect(_ toSpotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        maskLayer.add(moveAnimation(duration, toSpotlight: toSpotlight), forKey: nil)
        spotlights = [toSpotlight]
    }
    
    private func moveDisappear(_ toSpotlight: SpotlightType, duration: TimeInterval = SpotlightView.defaultAnimateDuration) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.appear(toSpotlight, duration: duration)
            self.spotlights = [toSpotlight]
        }
        disappear(duration)
        CATransaction.commit()
    }
    
    private func maskPath(_ path: UIBezierPath) -> UIBezierPath {
        [path].reduce(into: UIBezierPath(rect: frame)) { $0.append($1) }
    }
    
    private func appearAnimation(_ duration: TimeInterval, spotlights: [SpotlightType]) -> CAAnimation {
        typealias PathAnimationPair = (begin: UIBezierPath?, end: UIBezierPath)
        let pair = spotlights.reduce(into: PathAnimationPair(begin: .init(rect: frame), end: .init(rect: frame))) { (result, spotlight) in
            result.begin?.append(spotlight.infinitesmalPath)
            result.end.append(spotlight.path)
        }
        return pathAnimation(duration, beginPath: pair.begin, endPath: pair.end)
    }
    
    private func disappearAnimation(_ duration: TimeInterval) -> CAAnimation {
        let convergence = spotlights.removeLast()
        return pathAnimation(duration, beginPath: nil, endPath: maskPath(convergence.infinitesmalPath))
    }
    
    private func moveAnimation(_ duration: TimeInterval, toSpotlight: SpotlightType) -> CAAnimation {
        let endPath = maskPath(toSpotlight.path)
        return pathAnimation(duration, beginPath: nil, endPath: endPath)
    }

    private func pathAnimation(_ duration: TimeInterval, beginPath: UIBezierPath?, endPath: UIBezierPath) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0, 0.33, 1)
        if let path = beginPath {
            animation.fromValue = path.cgPath
        }
        animation.toValue = endPath.cgPath
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }
}

public enum SpotlightMoveType {
    case direct
    case disappear
}
