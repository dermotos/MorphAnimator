# MorphAnimator

![animated-example](https://user-images.githubusercontent.com/1140466/214097087-47372922-57e5-44c8-bafe-1cf3a6c1d4c9.gif)

## Overview

### What is this?

This is a custom UIViewController transition system. It automatically morphs the views from the first view controller to those in the second view controller. The public interface is minimal and generic, requiring only a dictionary of views the view controller developer considers "Views of Interest". 

### Why use this over manually created transitions?

On large projects, it is common to break down features into different teams of developers. Visually, the boundaries between the various teams responsibilities lies between view controllers. For example, one team might be responsible for the login screen. After a successful login the user is transitioned to the main menu screen, built by a different team. The reality of creating a manual transition between these two screens results in a lot of coordination between the two teams. Any visual changes such as positions of views etc. Ultimately, this usually results in the transition being considered too much effort and dropped. The MorphAnimator's aim is to ensure the transitions are dynamically generated based on the two views, and automatically adjust itself if the views or their positions change. The API is very simple, and only requires that the two teams agree upon common identifers for the views they wish to morph from one screen to the other.

### Public Interface

Simply confirm your two view controllers to `MorphAnimatorViewSource`. Both view controllers should agree upon common keys to identify which origin view morphs into which destination view. To generate a portal effect (like the animated example above), just return your view from the `portalView()` method. For the destination, if no portal view is specified, it is assumed to be the full view controller.

The below code is all that is needed to generate the transition you see in the gif above.

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

Heh!, not quite yet, but it is getting there. 
Feel free to submit a pull request if you find this useful and have made some improvements or additions! Otherwise, I'll get around to it eventually.
There is still a lot of edge cases that must be addressed. Better support for rounded corners, improved portal effects, masked views, transparency, text etc... there are a lot of optimisations and improvements that can be made. I hope to work on this more in 2023 

<sub>I really hope no one is reading this in 2028 and I've committed nothing further so far</sub>


## Suggested review process

If you'd like to read and understand this code, I suggest looking at it in the following order:

1. The Sample app, namely the `MorphAnimatorViewSource` conformance and what it provides to the animator.
2. Look at the `UINavigationControllerExtension.swift` file, and what the extension asks of the _view sources_.
3. `Transitioning`. A simple class that calls the animator from a standard `UIViewControllerAnimatedTransitioning` object.
4. `Scene` object, namely its initializer. A "scene" is an abstraction of all the details we want to animate, strutured in a way that is better suited for animation.
4. `Morph.Animator`. Yes, the initializers definitely need refactoring, but ignoring that for the minute, observe how the initializer looks at the "scene" and creates a series of animatable layers for what it needs to animate.
5. The `Morph.Animator.prepare()` and `.animate()` methods. These setup and then animate, respectively, the animatable layers created from the scene.

