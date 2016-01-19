//
//  AnnotationViewController.swift
//  Gecco
//
//  Created by Asai.Yuki on 2016/01/19.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var annotationViews: [UIView]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        updateAnnotationView(false)
    }
    
    func next() {
        stepIndex++
        switch stepIndex {
        case 1:
            spotlightView.move(0.25, fromSpotlight: nil, toSpotlight: Spotlight.Oval(center: CGPointMake(300, 42), width: 50))
        case 2:
            spotlightView.move(0.25, fromSpotlight: nil, toSpotlight: Spotlight.RoundedRect(center: CGPointMake(375 / 2, 42), size: CGSizeMake(120, 40), radius: 6), moveType: .Disappear)
        case 3:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
        
        updateAnnotationView(true)
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
        next()
    }
}