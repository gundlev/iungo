//
//  TransitionManager.swift
//  MyLocation
//
//  Created by Niklas Gundlev on 14/05/15.
//  Copyright (c) 2015 Niklas Gundlev. All rights reserved.
//
import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var present = true
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransformMakeTranslation(container!.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container!.frame.width/2, 0)
        
        // start the toView to the right of the screen
        if (present) {
            toView.transform = offScreenRight
            container!.addSubview(fromView)
            container!.addSubview(toView)
        } else {
            toView.transform = offScreenLeft
            container!.addSubview(toView)
            container!.addSubview(fromView)
        }
        
        
        // add the both views to our view controller
//        container!.addSubview(fromView)
//        container!.addSubview(toView)
        
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        
        let dur:NSTimeInterval = NSTimeInterval(0.7)
        let del:NSTimeInterval = NSTimeInterval(0.0)
        let springDamp:CGFloat = CGFloat(2)
        let initialDamp:CGFloat = CGFloat(0.0)
        
        UIView.animateWithDuration(dur, delay: del, usingSpringWithDamping: springDamp, initialSpringVelocity: initialDamp, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
            if (self.present) {
                fromView.transform = offScreenLeft
            } else {
                fromView.transform = offScreenRight
            }
            
            
            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        present = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        present = false
        return self
    }
    
}

