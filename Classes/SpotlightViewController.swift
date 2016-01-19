//
//  SpotlightViewController.swift
//  Gecco
//
//  Created by Asai.Yuki on 2016/01/15.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public protocol SpotlightViewControllerDelegate: class {
    func spotlightViewControllerTapped(viewController: SpotlightViewController)
}

public class SpotlightViewController: UIViewController {
    
    public var delegate: SpotlightViewControllerDelegate?
    
    lazy var transitionController: SpotlightTransitionController = {
        let controller = SpotlightTransitionController()
        controller.delegate = self
        return controller
    }()
    
    public lazy var spotlightView: SpotlightView = {
        let view = SpotlightView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.userInteractionEnabled = false
        self.view.insertSubview(view, atIndex: 0)
        self.view.addConstraints([NSLayoutAttribute.Top, .Bottom, .Left, .Right].map {
            NSLayoutConstraint(item: self.view, attribute: $0, relatedBy: .Equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
            })
        return view
    }()
    
    public lazy var contentView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(view)
        self.view.addConstraints([NSLayoutAttribute.Top, .Bottom, .Left, .Right].map {
            NSLayoutConstraint(item: self.view, attribute: $0, relatedBy: .Equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
            })
        return view
    }()
    
    public var spotlight: Spotlight {
        get { return spotlightView.spotlight }
        set { spotlightView.spotlight = newValue }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        modalPresentationStyle = .OverCurrentContext
        transitioningDelegate = self
        
        setupTapGesture()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: "viewTapped:");
        view.addGestureRecognizer(gesture)
    }
}

extension SpotlightViewController {
    func viewTapped(gesture: UITapGestureRecognizer) {
        delegate?.spotlightViewControllerTapped(self)
    }
}

extension SpotlightViewController: SpotlightTransitionControllerDelegate {
    func spotlightTransitionWillPresent(controller: SpotlightTransitionController, transitionContext: UIViewControllerContextTransitioning) {
        spotlightView.appear(duration: controller.transitionDuration(transitionContext))
    }
    
    func spotlightTransitionWillDismiss(controller: SpotlightTransitionController, transitionContext: UIViewControllerContextTransitioning) {
        spotlightView.disappear(controller.transitionDuration(transitionContext))
    }
}

extension SpotlightViewController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionController.isPresent = true
        return transitionController
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionController.isPresent = false
        return transitionController
    }
}
