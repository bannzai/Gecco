//
//  SpotlightContentView.swift
//  Gecco
//
//  Created by Shannon Wu on 3/29/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import UIKit

public class SpotlightContentView: UIView
{
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if let vc = controller as? SpotlightViewController, gr = vc.forwardGestureRecognizer
        {
            return gr.view?.hitTest(point, withEvent: event)
        }
        return super.hitTest(point, withEvent: event)
    }
}
