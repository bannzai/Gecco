//
//  ViewController.swift
//  GeccoExample
//
//  Created by yukiasai on 2016/01/15.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var annotationViewController: AnnotationViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        presentAnnotation()
    }
    
    func presentAnnotation() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Annotation") as! AnnotationViewController
        presentViewController(viewController, animated: true, completion: nil)
        annotationViewController = viewController
    }
}


