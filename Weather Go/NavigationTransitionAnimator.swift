//
//  NavigationTransitionAnimator.swift
//  Weather Go
//
//  Created by Kevin Guo on 2017-03-06.
//  Copyright © 2017 Kevin Guo. All rights reserved.
//

import Foundation
import UIKit

class NavigationTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var reverse: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)

        let fromView = fromVc?.view
        let toView = toVc?.view
        
        
        if let fromView = fromView, let toView = toView {
            

            let upperRect = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height / 2)
            let upperView = self.reverse ? toView.snapshotOfView(bound: upperRect) : fromView.snapshotOfView(bound: upperRect)
            upperView?.frame = upperRect
            
            let lowerRect = CGRect(x: 0, y: fromView.frame.height / 2, width: fromView.frame.width, height: fromView.frame.height / 2)
            let lowerView = self.reverse ? toView.snapshotOfView(bound: lowerRect) : fromView.snapshotOfView(bound: lowerRect)
            lowerView?.frame = lowerRect
            
            let outUpperAnim = CGAffineTransform(translationX: 0, y: -(containerView.frame.height / 2)) // upper view slide out
            let outLowerAnim = CGAffineTransform(translationX: 0, y: (containerView.frame.height / 2))  // lower view slide out
            
            let inLowerAnim = CGAffineTransform(translationX: 0, y: (containerView.frame.height / 2.0)) // lower view slide in
            let inOuterAnim = CGAffineTransform(translationX: 0, y: -(containerView.frame.height) / 2.0)// upper view slide out
            let inAnim = CGAffineTransform(translationX: 0, y: (containerView.frame.height / 2.0))      // view slide in
            
            if self.reverse {
                // goes out
                
                // detail page stack on top, half half page at the bottom
                containerView.addSubview(toView)
                containerView.addSubview(upperView!)
                containerView.addSubview(lowerView!)
                containerView.addSubview(fromView)
                containerView.sendSubview(toBack: upperView!)
                containerView.sendSubview(toBack: lowerView!)
                containerView.sendSubview(toBack: toView)
                
                upperView?.transform = inOuterAnim  // gonna slide from to top to identity, ready to be animated
                lowerView?.transform = inLowerAnim  // gonna slide from bottom to identity, ready to be animated
                
            } else {
                // goes in
                
                // half half page on top, detail page at the bottom
                containerView.addSubview(toView)
                containerView.addSubview(upperView!)
                containerView.addSubview(lowerView!)
                containerView.sendSubview(toBack: fromView)
                
                // in this case the toView is the detail weather page,
                toView.transform = inAnim  // sets toView in half screen position, ready to be animated
                
            }
            toView.alpha = 1

            UIView.animate(withDuration: self.transitionDuration(using: transitionContext) * 1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                if self.reverse {
                    
                    fromView.transform = outLowerAnim // slide down till half of the page
                    fromView.alpha = 0                // and fade away
                    
                    upperView?.transform = CGAffineTransform.identity
                    lowerView?.transform = CGAffineTransform.identity
                    
                } else {
                    // goes in
                    toView.transform = CGAffineTransform.identity // enter and cover the main screen
                    
                    upperView?.transform = outUpperAnim // slide up off screen
                    lowerView?.transform = outLowerAnim // slide down off screen
                }

                
//                
//                toView.alpha = 1
//                toView.transform = CGAffineTransform.identity
////                fromView.transform = self.reverse ? inAnim : outAnim
////                fromView.alpha = 0
//                
//                lowerView?.transform = self.reverse ? inLowerAnim : outLowerAnim
//                upperView?.transform = self.reverse ? inAnim : outUpperAnim
//                
//                lowerView?.alpha = 0
//                upperView?.alpha = 0
//                
                
            }, completion: { (success) in
                if (transitionContext.transitionWasCancelled) {
                    if self.reverse {
                        
                    } else {
                        
                    }
                    
                    toView.removeFromSuperview()
                } else {
                    if self.reverse {
                        lowerView?.removeFromSuperview()
                        upperView?.removeFromSuperview()
                    } else {
                        fromView.removeFromSuperview()
                    }
                    
                    //fromView.removeFromSuperview()
                }

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    
//      fade
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//        let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//        
//        let fromView = fromVc?.view
//        let toView = toVc?.view
//        
//        if let fromView = fromView, let toView = toView {
//            toView.alpha = 0
//            
//            containerView.addSubview(toView)
//            containerView.addSubview(fromView)
//            
//            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
//                fromView.alpha = 0
//                toView.alpha = 1
//                
//            }, completion: { (success) in
//                
//                if (transitionContext.transitionWasCancelled) {
//                    toView.removeFromSuperview()
//                } else {
//                    fromView.removeFromSuperview()
//                }
//                
//                
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            })
//        }
//        
//    }
}