//
//  Spotlight.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/17.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

public class Spotlight {
    public enum Shape {
        case Oval(center: CGPoint, width: CGFloat)
        case Rect(center: CGPoint, size: CGSize)
        case RoundedRect(center: CGPoint, size: CGSize, radius: CGFloat)
        case OvalWV(center: UIView, margin: CGFloat)
        case RectWV(center: UIView, margin: CGFloat)
        case RoundedRectWV(center: UIView, radius: CGFloat, margin: CGFloat)
        
        public var frame: CGRect {
            return frameWith(center, size: size)
        }
        
        public var center: CGPoint {
            switch self {
            case .Oval(let center, _):
                return center
            case .Rect(let center, _):
                return center
            case .RoundedRect(let center, _, _):
                return center
            case .OvalWV(let view, _):
                return center(view)
            case .RectWV(let view, _):
                return center(view)
            case .RoundedRectWV(let view, _, _):
                return center(view)
            }
        }
        
        public var size: CGSize {
            switch self {
            case .Oval(_, let width):
                return CGSizeMake(width, width)
            case .Rect(_, let size):
                return size
            case .RoundedRect(_, let size, _):
                return size
            case .OvalWV(let view, let margin):
                return ovalSize(view, margin: margin)
            case .RectWV(let view, let margin):
                return rectSize(view, margin: margin)
            case .RoundedRectWV(let view, radius: _, let margin):
                return rectSize(view, margin: margin)
            }
        }
        
        var path: UIBezierPath {
            switch self {
            case .Oval(_, let width):
                return UIBezierPath(roundedRect: frame, cornerRadius: width / 2)
            case .Rect(_, _):
                return UIBezierPath(roundedRect: frame, cornerRadius: 0)
            case .RoundedRect(_, _, let radius):
                return UIBezierPath(roundedRect: frame, cornerRadius: radius)
            case .OvalWV(let view, let margin):
                return UIBezierPath(roundedRect: frame, cornerRadius: radius(view, margin: margin))
            case .RectWV(center: _, _):
                return UIBezierPath(roundedRect: frame, cornerRadius: 0)
            case .RoundedRectWV(_, let radius, _):
                return UIBezierPath(roundedRect: frame, cornerRadius: radius)
            }
        }
        
        var infinitesmalPath: UIBezierPath {
            switch self {
            case .Oval(_, let width):
                return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: width / 2)
            case .Rect(_, _):
                return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: 0)
            case .RoundedRect(_, _, let radius):
                return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: radius)
            case .OvalWV(let view, let margin):
                return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: radius(view, margin: margin))
            case .RectWV(_, _):
                return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: 0)
            case .RoundedRectWV(_, let radius, _):
                return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: radius)
            }
        }
        
        func frameWith(center: CGPoint, size: CGSize) -> CGRect {
            return CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height)
        }
        
        private func center(view: UIView) -> CGPoint {
            let viewOrigin = view.superview!.convertPoint(view.frame.origin, toCoordinateSpace: view.window!.screen.fixedCoordinateSpace)
            return CGPointMake(viewOrigin.x + view.frame.size.width / 2, viewOrigin.y + view.frame.size.height / 2)
        }
        
        private func rectSize(view: UIView, margin: CGFloat) -> CGSize {
            return CGSizeMake(view.bounds.size.width + margin * 2, view.bounds.size.height + margin * 2)
        }
        
        private func ovalSize(view: UIView, margin: CGFloat) -> CGSize {
            let width = view.bounds.size.width + margin * 2
            let height = view.bounds.size.height + margin * 2
            
            return width > height ? CGSizeMake(width, width) : CGSizeMake(height, height)
        }
        
        private func radius(view: UIView, margin: CGFloat) -> CGFloat {
            return sqrt(pow(view.bounds.size.width + margin * 2, 2) + pow(view.bounds.size.height + margin * 2, 2)) / 2
        }
    }
    
    convenience public init(shape: Shape) {
        self.init()
        self.shape = shape
    }
    
    public var shape: Shape = .Oval(center: CGPointZero, width: 100)
    
    var infinitesmalPath: UIBezierPath {
        return self.shape.infinitesmalPath
    }
    
    var path: UIBezierPath {
        return self.shape.path
    }
    
    var frame: CGRect {
        return self.shape.frame
    }
}
