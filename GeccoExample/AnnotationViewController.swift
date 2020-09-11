//
//  AnnotationViewController.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/19.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit
import Gecco

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var annotationViews: [UIView]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }

    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)

        let rigtBarButtonFrames = extractRightBarButtonConvertedFrames()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight: CGFloat = 44
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.Oval(center: CGPoint(x: rigtBarButtonFrames.first.midX, y: rigtBarButtonFrames.first.midY), diameter: 50))
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: rigtBarButtonFrames.second.midX, y: rigtBarButtonFrames.second.midY), diameter: 50))
        case 2:
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: statusBarHeight + navigationBarHeight / 2), size: CGSize(width: 120, height: 40), cornerRadius: 6), moveType: .disappear)
        case 3:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: 200 + view.safeAreaInsets.top), diameter: 220), moveType: .disappear)
        case 4:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(_ animated: Bool) {
        annotationViews.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

private extension AnnotationViewController {
    var viewControllerHasNavigationItem: UIViewController? {
        if let navigationController = presentingViewController as? UINavigationController {
            return navigationController.viewControllers[0]
        }
        return presentingViewController
    }
    
    func extractRightBarButtonConvertedFrames() -> (first: CGRect, second: CGRect) {
        guard
            let firstRightBarButtonItem = viewControllerHasNavigationItem?.navigationItem.rightBarButtonItems?[0].value(forKey: "view") as? UIView,
            let secondRightBarButtonItem = viewControllerHasNavigationItem?.navigationItem.rightBarButtonItems?[1].value(forKey: "view") as? UIView
            else {
                fatalError("Unexpected extract view from UIBarButtonItem via value(forKey:)")
        }
        return (
            first: firstRightBarButtonItem.convert(firstRightBarButtonItem.bounds, to: view),
            second: secondRightBarButtonItem.convert(secondRightBarButtonItem.bounds, to: view)
        )
    }

}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
