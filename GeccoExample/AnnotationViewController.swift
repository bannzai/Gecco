//
//  AnnotationViewController.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/19.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var annotationViews: [UIView]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        next(false)
    }
    
    func next(animated: Bool) {
        switch stepIndex {
        case 0:
            spotlight = Spotlight.Oval(center: CGPointMake(349, 42), width: 50)
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(300, 42), width: 50))
        case 2:
            spotlightView.move(Spotlight.RoundedRect(center: CGPointMake(375 / 2, 42), size: CGSizeMake(120, 40), radius: 6), moveType: .Disappear)
        case 3:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(375 / 2, 200), width: 220), moveType: .Disappear)
        case 4:
            dismissViewControllerAnimated(animated, completion: nil)
        default:
            break
        }
        updateAnnotationView(animated)
        
        stepIndex++
    }
    
    func updateAnnotationView(animated: Bool) {
        annotationViews.enumerate().forEach { index, view in
            UIView .animateWithDuration(animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerTapped(viewController: SpotlightViewController) {
        next(true)
    }
}