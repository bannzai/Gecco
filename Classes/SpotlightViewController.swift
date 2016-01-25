//
//  SpotlightViewController.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/15.
//  Copyright (c) 2016 yukiasai. All rights reserved.
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
    
    public let spotlightView = SpotlightView()
    public let contentView = UIView()
    
    public var spotlight: Spotlight {
        get { return spotlightView.spotlight }
        set { spotlightView.spotlight = newValue }
    }

    public var alpha: CGFloat = 0.5

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        modalPresentationStyle = .OverCurrentContext
        transitioningDelegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpotlightView(alpha)
        setupContentView()
        setupTapGesture()
        
        view.backgroundColor = UIColor.clearColor()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupSpotlightView(alpha: CGFloat) {
        spotlightView.frame = view.bounds
        spotlightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        spotlightView.userInteractionEnabled = false
        view.insertSubview(spotlightView, atIndex: 0)
        view.addConstraints([NSLayoutAttribute.Top, .Bottom, .Left, .Right].map {
            NSLayoutConstraint(item: view, attribute: $0, relatedBy: .Equal, toItem: spotlightView, attribute: $0, multiplier: 1, constant: 0)
            })
    }
    
    private func setupContentView() {
        contentView.frame = view.bounds
        contentView.backgroundColor = UIColor.clearColor()
        view.addSubview(contentView)
        view.addConstraints([NSLayoutAttribute.Top, .Bottom, .Left, .Right].map {
            NSLayoutConstraint(item: view, attribute: $0, relatedBy: .Equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
            })
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
