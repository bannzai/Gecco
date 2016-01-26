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
            }
        }
        
        func frameWith(center: CGPoint, size: CGSize) -> CGRect {
            return CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height)
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
