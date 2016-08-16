//
//  SpotlightViewController.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/15.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

@objc public protocol SpotlightViewControllerDelegate: class {
    @objc optional func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool)
    @objc optional func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool)
    @objc optional func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool)
}

open class SpotlightViewController: UIViewController {
    
    open weak var delegate: SpotlightViewControllerDelegate?
    
    fileprivate lazy var transitionController: SpotlightTransitionController = {
        let controller = SpotlightTransitionController()
        controller.delegate = self
        return controller
    }()
    
    open let spotlightView = SpotlightView()
    open let contentView = UIView()
    
    open var alpha: CGFloat = 0.5

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpotlightView(alpha)
        setupContentView()
        setupTapGesture()
        
        view.backgroundColor = UIColor.clear
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func setupSpotlightView(_ alpha: CGFloat) {
        spotlightView.frame = view.bounds
        spotlightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        spotlightView.isUserInteractionEnabled = false
        view.insertSubview(spotlightView, at: 0)
        view.addConstraints([NSLayoutAttribute.top, .bottom, .left, .right].map {
            NSLayoutConstraint(item: view, attribute: $0, relatedBy: .equal, toItem: spotlightView, attribute: $0, multiplier: 1, constant: 0)
            })
    }
    
    fileprivate func setupContentView() {
        contentView.frame = view.bounds
        contentView.backgroundColor = UIColor.clear
        view.addSubview(contentView)
        view.addConstraints([NSLayoutAttribute.top, .bottom, .left, .right].map {
            NSLayoutConstraint(item: view, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
            })
    }
    
    fileprivate func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SpotlightViewController.viewTapped(_:)));
        view.addGestureRecognizer(gesture)
    }
}

extension SpotlightViewController {
    func viewTapped(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: spotlightView)
        let isInside = spotlightView.spotlight?.frame.contains(touchPoint) ?? false
        delegate?.spotlightViewControllerTapped?(self, isInsideSpotlight: isInside)
    }
}

extension SpotlightViewController: SpotlightTransitionControllerDelegate {
    func spotlightTransitionWillPresent(_ controller: SpotlightTransitionController, transitionContext: UIViewControllerContextTransitioning) {
        delegate?.spotlightViewControllerWillPresent?(self, animated: transitionContext.isAnimated)
    }
    
    func spotlightTransitionWillDismiss(_ controller: SpotlightTransitionController, transitionContext: UIViewControllerContextTransitioning) {
        delegate?.spotlightViewControllerWillDismiss?(self, animated: transitionContext.isAnimated)
    }
}

extension SpotlightViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionController.isPresent = true
        return transitionController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionController.isPresent = false
        return transitionController
    }
}
