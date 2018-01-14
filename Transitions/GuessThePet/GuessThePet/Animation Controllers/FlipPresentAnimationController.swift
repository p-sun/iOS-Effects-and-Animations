///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

  private let originFrame: CGRect
  
  init(originFrame: CGRect) {
    self.originFrame = originFrame
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 2.0
  }

  // This animates the "from" view and the "to" snapshot by rotating and scaling.
  // It also appropriately hides/unhides the "to" view before and after the animation.
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // Get the "to" snapshot -- an image of the screen after the transition
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),
      let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
      else {
        return
    }
    
    // Configure the "to" snapshot’s frame so it exactly covers the “from” view.
    snapshot.frame = originFrame
    snapshot.layer.cornerRadius = CardViewController.cardCornerRadius
    snapshot.layer.masksToBounds = true
    
    // Add the new “to” view to the view hierarchy and HIDE it.
    let containerView = transitionContext.containerView
    containerView.addSubview(toVC.view)
    toVC.view.isHidden = true
    // Place the "to" snapshot in front of it.
    containerView.addSubview(snapshot)
    
    // Hide the "to" snapshot by rotating it 90˚ around its y-axis
    // (This causes it to be edge-on to the viewer and, therefore, not visible when the animation begins.)
    AnimationHelper.perspectiveTransform(for: containerView)
    snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
    
    // Get the final frame of the transition
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    // Animate key frames! The duration of the animation exactly match the length of the transition
    let duration = transitionDuration(using: transitionContext)
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        // Hide the "from" view by rotating it 90˚
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
          fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
        }
        
        // Reveal the "to" snapshot by rotating it 90˚
        UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
          snapshot.layer.transform = AnimationHelper.yRotation(0.0)
        }
        
        // Enlarge the "to" snapshot frame to fill the screen. Now the "to" snapshot matches the "to" view.
        UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
          snapshot.frame = finalFrame
          snapshot.layer.cornerRadius = 0
        }
    },
      completion: { _ in
        // Reveal the real "to" view, and remove the "to" snapshot.
        toVC.view.isHidden = false
        snapshot.removeFromSuperview()
        
        // Restore the “from” view to its original state. (Otherwise, it would be hidden when transitioning back)
        fromVC.view.layer.transform = CATransform3DIdentity
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
