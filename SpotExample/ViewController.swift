//
//  ViewController.swift
//  SpotExample
//
//  Created by Asai.Yuki on 2016/01/15.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewController = SpotlightViewController()
        viewController.spotlight = Spotlight.Oval(center: CGPointMake(150, 70), width: 80)
        presentViewController(viewController, animated: true, completion: nil)
    }

}

