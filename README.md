# Gecco

[![Pod Version](http://img.shields.io/cocoapods/v/Gecco.svg?style=flat)](http://cocoadocs.org/docsets/Gecco/)
[![Pod Platform](http://img.shields.io/cocoapods/p/Gecco.svg?style=flat)](http://cocoadocs.org/docsets/Gecco/)
[![Pod License](http://img.shields.io/cocoapods/l/Gecco.svg?style=flat)](http://opensource.org/licenses/MIT)

Simply highlight items for your tutorial walkthrough, written in Swift

Gecco means Moonlight in Japanese.

![Demo](https://cloud.githubusercontent.com/assets/6880730/12470510/2d1cb602-c038-11e5-8095-a2a0d77f99db.gif)

## Usage

### Basic

Basically instantiate a SpotlightViewController and present via `UIViewController.present(_:animated:completion) and call `SpotlightViewController.spotlight.appear(_:)` with SpotlightType.

``` swift
import Gecco

class ViewController: UIViewController {
  func showSpotlight() {
    let spotlightViewController = SpotlightViewController()
    present(spotlightViewController, animated: true, completion: nil)
    spotlightViewController.spotlightView.appear(Spotlight.Oval(center: view.center, diameter: 100))
  }
}
```

#### Supported SpotlightType
Gecco provide some SpotlightType as default implemantation.

<details> <summary> Oval </summary>

`Oval` displays a perfect circle.
```swift
spotlightViewController.spotlightView.appear(Spotlight.Oval(center: view.center, diameter: 100))
```

<img width="320px" src="https://user-images.githubusercontent.com/10897361/93325274-0601a800-f852-11ea-813b-9583be0f4335.png" />

</details>

<details> <summary> Rect </summary>

`Rect` is a rectangle drawn by specifying the width and height.
```swift
spotlightViewController.spotlightView.appear(Spotlight.Rect(center: view.center, size: CGSize(width: 200, height: 100)))
```

<img width="320px" src="https://user-images.githubusercontent.com/10897361/93325566-790b1e80-f852-11ea-85a6-5fed5204a56d.png" />

</details>

<details> <summary> RoundedRect </summary>

`RoundedRect` is a rectangle with corner radius.
```swift
spotlightViewController.spotlightView.appear(Spotlight.RoundedRect(center: view.center, size: CGSize(width: 200, height: 100), cornerRadius: 8))
```

<img width="320px" src="https://user-images.githubusercontent.com/10897361/93325669-9b04a100-f852-11ea-9afa-b9fac06ba0b2.png" />

</details>

### Advanced
**Gecco** publish some delegate methods for hook each events about SpotlightViewController and SpotlightView.
If you want to write adavanced feature, you can write to define SpotlightViewControllerDelegate or SpotlightViewDelegate.
See [SpotlightViewControllerDelegate](https://github.com/yukiasai/Gecco/blob/9791f0c050572f43d54a7f13dc081a165d99e9f3/Classes/SpotlightViewController.swift#L11) and [SpotlightViewDelegate](https://github.com/yukiasai/Gecco/blob/9791f0c050572f43d54a7f13dc081a165d99e9f3/Classes/SpotlightView.swift#L11).

For example
```swift
// Hook events for SpotlightViewControllerDelegate
spotlightViewController.delegate = self

// Hook events for SpotlightViewDelegate
spotlightViewController.spotlightView.delegate = self
```

### Example
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
