# Gecco

Spotlight view for iOS.

![Demo](https://cloud.githubusercontent.com/assets/6880730/12470510/2d1cb602-c038-11e5-8095-a2a0d77f99db.gif)

## Usage

#### Basic

``` swift
import Gecco

class ViewController: UIViewController {
  func showSpotlight() {
    let spotlightViewController = SpotlightViewController()
    spotlightViewController.spotlight = Spotlight.Oval(center: CGPointMake(100, 100), width: 100)
    presentViewController(spotlightViewController, animated: true, completion: nil)
  }
}
```

#### Custom

Please refer to [GeccoExample](https://github.com/yukiasai/Gecco/tree/master/GeccoExample).

## Installation

#### Cocoapods

```
pod 'Gecco'
```

## License

Gecco is released under the MIT license. See LICENSE for details.
