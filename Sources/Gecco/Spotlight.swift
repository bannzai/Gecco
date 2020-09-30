//
//  Spotlight.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/17.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

public protocol SpotlightType {
    var frame: CGRect { get }
    var center: CGPoint { get }
    var path: UIBezierPath { get }
    var infinitesmalPath: UIBezierPath { get }
}

public extension SpotlightType {
    var center: CGPoint {
        return CGPoint(x: frame.midX, y: frame.midY)
    }
    
    var infinitesmalPath: UIBezierPath {
        return UIBezierPath(roundedRect: CGRect(origin: center, size: CGSize.zero), cornerRadius: 0)
    }
}

public struct Spotlight {
    public struct Oval: SpotlightType, Equatable {
        public var frame: CGRect
        public init(frame: CGRect) {
            self.frame = frame
        }
        
        public init(center: CGPoint, diameter: CGFloat) {
            let frame = CGRect(x: center.x - diameter / 2, y: center.y - diameter / 2, width: diameter, height: diameter)
            self.init(frame: frame)
        }
        
        public init(view: UIView, margin: CGFloat) {
            let origin = view.superview!.convert(view.frame.origin, to: view.window!.screen.fixedCoordinateSpace)
            let center = CGPoint(x: origin.x + view.bounds.width / 2, y: origin.y + view.bounds.height / 2)
            let diameter = max(view.bounds.width, view.bounds.height) + margin * 2
            self.init(center: center, diameter: diameter)
        }
        
        public var path: UIBezierPath {
            return UIBezierPath(roundedRect: frame, cornerRadius: frame.width / 2)
        }
    }
    
    public struct Rect: SpotlightType, Equatable {
        public var frame: CGRect
        public init(frame: CGRect) {
            self.frame = frame
        }
        
        public init(center: CGPoint, size: CGSize) {
            let frame = CGRect(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
            self.frame = frame
        }
        
        public init(view: UIView, margin: CGFloat) {
            let viewOrigin = view.superview!.convert(view.frame.origin, to: view.window!.screen.fixedCoordinateSpace)
            let origin = CGPoint(x: viewOrigin.x - margin, y: viewOrigin.y - margin)
            let size = CGSize(width: view.bounds.width + margin * 2, height: view.bounds.height + margin * 2)
            self.frame = CGRect(origin: origin, size: size)
        }
        
        public var path: UIBezierPath {
            return UIBezierPath(roundedRect: frame, cornerRadius: 0)
        }
    }
    
    public struct RoundedRect: SpotlightType, Equatable {
        public var frame: CGRect
        public var cornerRadius: CGFloat
        public init(frame: CGRect, cornerRadius: CGFloat) {
            self.frame = frame
            self.cornerRadius = cornerRadius
        }

        public init(center: CGPoint, size: CGSize, cornerRadius: CGFloat) {
            let frame = CGRect(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
            self.init(frame: frame, cornerRadius: cornerRadius)
        }

        public init(view: UIView, margin: CGFloat, cornerRadius: CGFloat) {
            let viewOrigin = view.superview!.convert(view.frame.origin, to: view.window!.screen.fixedCoordinateSpace)
            let origin = CGPoint(x: viewOrigin.x - margin, y: viewOrigin.y - margin)
            let size = CGSize(width: view.bounds.width + margin * 2, height: view.bounds.height + margin * 2)
            let frame = CGRect(origin: origin, size: size)
            self.init(frame: frame, cornerRadius: cornerRadius)
        }

        public var path: UIBezierPath {
            return UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius)
        }
    }
}
