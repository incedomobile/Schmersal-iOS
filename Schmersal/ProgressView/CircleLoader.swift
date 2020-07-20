//
//  CircleLoader.swift
//  GeometricLoaders
//
//  Created by Pablo on 18/10/2017.
//  Copyright © 2017 Pablo. All rights reserved.
//

import UIKit

public class CircleLoader: GeometricLoader {
       public static let sharedInstance = CircleLoader()
    internal var shapeLayer = CAShapeLayer()
    internal var duration: CGFloat = 5.0
    
    internal var gradientLayer = CAGradientLayer()
    open var startGradientColor = MangoBlueColor.cgColor
    open var endGradientColor = MangoBlueColor.cgColor
    
    override internal func configureLoader() {
        setupGradientLayer()
        setupShapeLayer()
        setupAnimation()
    }
    
    private func setupGradientLayer() {
        
        gradientLayer.colors = [startGradientColor, endGradientColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = loaderView.bounds
        loaderView.layer.addSublayer(shapeLayer)
    }
    private func setupShapeLayer() {
        let center = CGPoint(x: loaderView.bounds.width/2, y: loaderView.bounds.height/2)
        //loaderView.frame.height/10
        shapeLayer.path = UIBezierPath(arcCenter: center, radius: 20, startAngle: 0, endAngle: 2*CGFloat(Float.pi), clockwise: true).cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineDashPattern = [4,2]
        shapeLayer.frame = loaderView.bounds
        gradientLayer.mask = shapeLayer
        loaderView.layer.addSublayer(gradientLayer)
        
    }
    private func strokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }
    private func strokeStartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }
    private func rotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2*CGFloat.pi
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = Float.infinity
        return animation
    }
    private func setupAnimation() {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeStartAnimation(),strokeEndAnimation(),rotationAnimation()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = CAMediaTimingFillMode.both
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity
        shapeLayer.add(animationGroup, forKey: "loading")
    }
}
