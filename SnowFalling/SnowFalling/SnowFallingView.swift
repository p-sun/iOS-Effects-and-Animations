//
//  SnowFallingView.swift
//  SnowFalling
//
//  Created by pixyzehn on 2/11/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

public let kDefaultFlakeFileName               = "snowflake"
public let kDefaultFlakesCount                 = 200
public let kDefaultFlakeWidth: Float           = 40.0
public let kDefaultFlakeHeight: Float          = 46.0
public let kDefaultMinimumSize: Float          = 0.4
public let kDefaultMaximumSize: Float          = 0.8
public let kDefaultAnimationDurationMin: Float = 6.0
public let kDefaultAnimationDurationMax: Float = 12.0

open class SnowFallingView: UIView {
    
    open var flakesCount: Int?
    open var flakeFileName: String?
    open var flakeWidth: Float?
    open var flakeHeight: Float?
    open var flakeMinimumSize: Float?
    open var flakeMaximumSize: Float?
    
    open var animationDurationMin: Float?
    open var animationDurationMax: Float?
    
    open var flakesArray: [UIImageView]?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds             = true
        self.flakeFileName        = kDefaultFlakeFileName
        self.flakesCount          = kDefaultFlakesCount
        self.flakeWidth           = kDefaultFlakeWidth
        self.flakeHeight          = kDefaultFlakeHeight
        self.flakeMinimumSize     = kDefaultMinimumSize
        self.flakeMaximumSize     = kDefaultMaximumSize
        self.animationDurationMin = kDefaultAnimationDurationMin
        self.animationDurationMax = kDefaultAnimationDurationMax
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /** Create an array of snow flakes, and set each flake's frame to a randomized position, width, and height.
     */
    open func createFlakes() {
        flakesArray = [UIImageView]()
        let flakeImage: UIImage = UIImage(named: flakeFileName!)!
        for _ in 0 ..< flakesCount! {
            var vz: Float = 1.0 * Float(arc4random()) / Float(RAND_MAX)
            vz = vz < flakeMinimumSize! ? flakeMinimumSize! : vz
            vz = vz > flakeMaximumSize! ? flakeMaximumSize! : vz
            
            let vw = flakeWidth! * vz
            let vh = flakeHeight! * vz
            
            var vx = Float(frame.size.width) * Float(arc4random()) / Float(RAND_MAX)
            var vy = Float(frame.size.height) * 1.5 * Float(arc4random()) / Float(RAND_MAX)
            
            vy += Float(frame.size.height)
            vx -= vw
            
            let imageFrame = CGRect(x: CGFloat(vx), y: CGFloat(vy), width: CGFloat(vw), height: CGFloat(vh))
            let imageView: UIImageView = UIImageView(image: flakeImage)
            imageView.frame = imageFrame
            imageView.isUserInteractionEnabled = false
            flakesArray?.append(imageView)
            addSubview(imageView)
        }
    }
    
    open func startSnow() {
        if flakesArray == nil {
            createFlakes()
        }
        backgroundColor = UIColor.clear
        
        let rotAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotAnimation.repeatCount = Float.infinity
        rotAnimation.autoreverses = false
        rotAnimation.toValue = 6.28318531
        
        let moveAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        moveAnimation.repeatCount = Float.infinity
        moveAnimation.autoreverses = false
        
        // Note that if you set kDefaultFlakesCount to 20, you can see each snowflake repeat its animation with the same size, speed, and starting position.
        for flake: UIImageView in flakesArray! {
            // Translation
            let startPointY = flake.center.y
            moveAnimation.fromValue = -startPointY

            let endPointY = frame.size.height
            flake.center.y = endPointY
            
            let timeInterval: Float = (animationDurationMax! - animationDurationMin!) * Float(arc4random()) / Float(RAND_MAX)
            moveAnimation.duration = CFTimeInterval(timeInterval + animationDurationMin!)
            
            flake.layer.add(moveAnimation, forKey: "transform.translation.y")
            
            // Rotation
            rotAnimation.duration = CFTimeInterval(timeInterval)
            flake.layer.add(rotAnimation, forKey: "transform.rotation.y")
        }
    }
    
    open func stopSnow() {
        for v: UIImageView in flakesArray! {
            v.layer.removeAllAnimations()
        }
        flakesArray = nil
    }
    
    deinit {
    }
}
