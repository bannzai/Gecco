# Gecco

[![Pod Version](http://img.shields.io/cocoapods/v/Gecco.svg?style=flat)](http://cocoadocs.org/docsets/Gecco/)
[![Pod Platform](http://img.shields.io/cocoapods/p/Gecco.svg?style=flat)](http://cocoadocs.org/docsets/Gecco/)
[![Pod License](http://img.shields.io/cocoapods/l/Gecco.svg?style=flat)](http://opensource.org/licenses/MIT)

Simply highlight items for your tutorial walkthrough, written in Swift

Gecco means Moonlight in Japanese.

![Demo](https://cloud.githubusercontent.com/assets/6880730/12470510/2d1cb602-c038-11e5-8095-a2a0d77f99db.gif)

## Usage

#### Basic

``` swift
import Gecco

class ViewController: UIViewController {
  func showSpotlight() {
    let spotlightViewController = SpotlightViewController()
    presentViewController(spotlightViewController, animated: true, completion: nil)
    spotlightViewController.spotlightView.appear(Spotlight.Oval(center: CGPointMake(100, 100), diameter: 100))
  }
}
```

#### Custom

Please refer to [GeccoExample](https://github.com/yukiasai/Gecco/tree/master/GeccoExample).

## Installation

#### CocoaPods

```
pod 'Gecco'
```
#### Carthage

```
github "yukiasai/Gecco"
```



## License

Gecco is released under the MIT license. See LICENSE for details.
