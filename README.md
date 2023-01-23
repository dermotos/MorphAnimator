# MorphAnimator

![Example](animated-example.gif?raw=true, "Example")

## Overview

### What is this?

This is a custom UIViewController transition system. It automatically morphs the views from the first view controller to those in the second view controller. The public interface is minimal and generic, requiring only a dictionary of views the view controller developer considers "Views of Interest". 

### Why use this over manually created transitions?

On large projects, it is common to break down features into different teams of developers. Visually, the boundaries between the various teams responsibilities lies between view controllers. For example, one team might be responsible for the login screen. After a successful login the user is transitioned to the main menu screen, built by a different team. The reality of creating a manual transition between these two screens results in a lot of coordination between the two teams. Any visual changes such as positions of views etc. Ultimately, this usually results in the transition being considered too much effort and dropped. The MorphAnimator's aim is to ensure the transitions are dynamically generated based on the two views, and automatically adjust itself if the views or their positions change. The API is very simple, and only requires that the two teams agree upon common identifers for the views they wish to morph from one screen to the other.

### Public Interface

Simply confirm your two view controllers to `MorphAnimatorViewSource`. Both view controllers should agree upon common keys to identify which origin view morphs into which destination view. To generate a portal effect (like the animated example above), just return your view from the `portalView()` method. For the destination, if no portal view is specified, it is assumed to be the full view controller.

```swift 

import MorphAnimator

...

extension FirstPortalViewController: MorphAnimatorViewSource {
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String : UIView]? {
        ["firstDot": firstDot,
         "secondDot": secondDot]
    }
    
    func portalView() -> UIView? {
        iconView
    }
}
```

```swift

import MorphAnimator

...

extension SecondPortalViewController: MorphAnimatorViewSource {
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String : UIView]? {
        ["firstDot": firstDot,
         "secondDot": secondDot]
    }

}
```

Finally to perform the animation, just call pushViewController, passing `.morph` instead of `true` for the `animated` parameter.

```swift

navigationController?.pushViewController(secondMorphViewController, animated: .morph)

```

Check out the example app in the SPM package for more details.


### Is this ready to be used?

Right now there are still some bugs to be ironed out, but it's getting there. Feel free to submit a pull request if you find this useful and have made some improvements or additions!
