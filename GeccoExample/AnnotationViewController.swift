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
    }
    
    func next() {
        stepIndex++
        switch stepIndex {
        case 1:
            spotlightView.move(0.25, fromSpotlight: nil, toSpotlight: Spotlight.Oval(center: CGPointMake(300, 42), width: 50))
        case 2:
            spotlightView.move(0.25, fromSpotlight: nil, toSpotlight: Spotlight.Oval(center: CGPointMake(375 / 2, 320), width: 200), moveType: .Disappear)
        case 3:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerTapped(viewController: SpotlightViewController) {
        next()
    }
}