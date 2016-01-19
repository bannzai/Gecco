//
//  Spotlight.swift
//  Gecco
//
//  Created by asai.yuki on 2016/01/17.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public enum Spotlight {
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
        case .Oval(_, _):
            return UIBezierPath(ovalInRect: frame)
        case .Rect(_, _):
            return UIBezierPath(rect: frame)
        case .RoundedRect(_, _, let radius):
            return UIBezierPath(roundedRect: frame, cornerRadius: radius)
        }
    }
    
    var infinitesmalPath: UIBezierPath {
        switch self {
        case .Oval(_, _):
            return UIBezierPath(ovalInRect: frameWith(center, size: CGSizeZero))
        case .Rect(_, _):
            return UIBezierPath(rect: frameWith(center, size: CGSizeZero))
        case .RoundedRect(_, _, let radius):
            return UIBezierPath(roundedRect: frameWith(center, size: CGSizeZero), cornerRadius: radius)
        }
    }
    
    func frameWith(center: CGPoint, size: CGSize) -> CGRect {
        return CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.width)
    }
}
