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
    lazy var geccoSpotlight = Spotlight.Oval(center: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 200 + view.safeAreaInsets.top), diameter: 220)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        spotlightView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAnnotationViewPosition()
    }

    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)

        let rightBarButtonFrames = extractRightBarButtonConvertedFrames()
        switch stepIndex {
        case 0:
            spotlightView.appear([Spotlight.Oval(center: CGPoint(x: rightBarButtonFrames.first.midX, y: rightBarButtonFrames.first.midY), diameter: 50), Spotlight.Oval(center: CGPoint(x: rightBarButtonFrames.second.midX, y: rightBarButtonFrames.second.midY), diameter: 50)])
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: rightBarButtonFrames.first.midX, y: rightBarButtonFrames.first.midY), diameter: 50), moveType: .disappear)
        case 2:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: rightBarButtonFrames.second.midX, y: rightBarButtonFrames.second.midY), diameter: 50), moveType: .direct)
        case 3:
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIApplication.shared.statusBarFrame.height + navigationBarHeight / 2), size: CGSize(width: 120, height: 40), cornerRadius: 6), moveType: .disappear)
        case 4:
            spotlightView.move(geccoSpotlight, moveType: .disappear)
        case 5:
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

extension AnnotationViewController: SpotlightViewDelegate {
    func spotlightWillAppear(spotlightView: SpotlightView, spotlight: SpotlightType) {
        print("\(#function): \(spotlight)")
    }
    func spotlightWillMove(spotlightView: SpotlightView, spotlight: (from: SpotlightType, to: SpotlightType), moveType: SpotlightMoveType) {
        print("\(#function): \(spotlight) is gecco spotlight?: \((spotlight.to as? Spotlight.Oval) == geccoSpotlight)")
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        next(true)
    }

    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}

private extension AnnotationViewController {
    func setupAnnotationViewPosition() {
        let rightBarButtonFrames = extractRightBarButtonConvertedFrames()
        annotationViews.enumerated().forEach { (offset, annotationView) in
            switch offset {
            case 0:
                annotationView.frame.origin.x = UIScreen.main.bounds.width - annotationView.frame.size.width - 20
                annotationView.frame.origin.y = rightBarButtonFrames.first.origin.y + 60
            case 1:
                annotationView.frame.origin.x = UIScreen.main.bounds.width - annotationView.frame.size.width - 20
                annotationView.frame.origin.y = rightBarButtonFrames.first.origin.y + 60
            case 2:
                annotationView.frame.origin.x = rightBarButtonFrames.second.origin.x - annotationView.frame.size.width / 2
                annotationView.frame.origin.y = rightBarButtonFrames.second.origin.y + 60
            case 3:
                annotationView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIApplication.shared.statusBarFrame.height + navigationBarHeight + 20)
            case 4:
                annotationView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 200 + view.safeAreaInsets.top)
            default:
                fatalError("unexpected index \(offset) for \(annotationView)")
            }
        }
    }

    var navigationBarHeight: CGFloat { 44 }
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
