//
//  ViewController.swift
//  SpotExample
//
//  Created by Asai.Yuki on 2016/01/15.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var stepIndex: Int = 0
    var spotlightViewController: SpotlightViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        next()
    }
    
    func next() {
        switch stepIndex {
        case 0:
            presentSpotlight()
        case 1:
            spotlightViewController?.spotlightView.move(0.25, fromSpotlight: nil, toSpotlight: Spotlight.Oval(center: CGPointMake(300, 42), width: 50))
        case 2:
            spotlightViewController?.spotlightView.move(0.25, fromSpotlight: nil, toSpotlight: Spotlight.Oval(center: CGPointMake(375 / 2, 320), width: 200), moveType: .Disappear)
        case 3:
            dismissSpotlight()
        default:
            break
        }
        stepIndex++
    }
    
    func presentSpotlight() {
        let viewController = SpotlightViewController()
        viewController.spotlight = Spotlight.Oval(center: CGPointMake(349, 42), width: 50)
        viewController.delegate = self
        presentViewController(viewController, animated: true, completion: nil)
        
        spotlightViewController = viewController
    }
    
    func dismissSpotlight() {
        dismissViewControllerAnimated(true) {
            self.spotlightViewController = nil
            self.stepIndex = 0
        }
    }
}

extension ViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerTapped(viewController: SpotlightViewController) {
        next()
    }
    
}

