//
//  Utils.swift
//  Gecco
//
//  Created by Shannon Wu on 3/29/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import UIKit

extension UIView {
    var controller: UIViewController? {
        get {
            let response = self.nextResponder()
            if (response as? UIView != nil)
            {
                return (response as! UIView).controller
            }
            else if (response as? UIViewController != nil)
            {
                return response as? UIViewController
            }
            else
            {
                return nil
            }
        }
    }
}

