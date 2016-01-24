//
//  Spotlight.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/17.
//  Copyright (c) 2016 yukiasai. All rights reserved.
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
    
    public static func calculateBarbuttonItemCenterPosition(barButtonItem: UIBarButtonItem, superView: UIView? = nil) -> CGPoint {
        
        let rootView = superView ?? UIApplication.sharedApplication().windows.last!
        if let customView = barButtonItem.customView {
            let point = targetViewOriginInSuperview(customView, currentOrigin: customView.frame.origin, rootView: rootView)
            return CGPointMake(point.x + customView.frame.width / 2, point.y + customView.frame.height / 2)
        }
        else if let view = barButtonItem.valueForKey("view") as? UIView {
            let point = targetViewOriginInSuperview(view.superview!, currentOrigin: view.frame.origin, rootView: rootView)
            return CGPointMake(point.x + view.frame.size.width / 2, point.y + view.frame.size.height / 2)
        }
        
        return CGPointZero
        
    }
    
    private static func targetViewOriginInSuperview(targetView: UIView, currentOrigin: CGPoint, rootView: UIView?) -> CGPoint {
        
        guard let containerView = targetView.superview else {
            return CGPointMake(targetView.frame.origin.x + currentOrigin.x, targetView.frame.origin.y + currentOrigin.y)
        }
        
        if let rootView = rootView {
            if targetView === rootView {
                return currentOrigin
            }
            else {
                return targetViewOriginInSuperview(containerView, currentOrigin: CGPointMake(targetView.frame.origin.x + currentOrigin.x, targetView.frame.origin.y + currentOrigin.y), rootView: rootView)
            }
        }
        else {
            return targetViewOriginInSuperview(containerView, currentOrigin: CGPointMake(targetView.frame.origin.x + currentOrigin.x, targetView.frame.origin.y + currentOrigin.y), rootView: nil)
        }
        
    }
    
}
