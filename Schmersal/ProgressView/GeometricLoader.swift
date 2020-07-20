//
//  GeometricLoader.swift
//  GeometricLoaders
//
//  Created by Pablo Garcia on 16/10/2017.
//  Copyright © 2017 Pablo Garcia. All rights reserved.
//

import UIKit

public class GeometricLoader: UIView {
    
    internal var loaderView = UIView()
    internal var loaderText = UILabel()
    internal var loaderSuperview: UIView?
    internal var isAnimating = false
    
    public static func createGeometricLoader() -> Self {
        
        let loader = self.init()
        loader.setupView()
        
        return loader
    }
    
    internal func configureLoader() {
        preconditionFailure("This method has to be called from GeometricLoader subclass")
    }
 
    open func startAnimation() {
        
        self.configureLoader()
        isHidden = false
        if superview == nil {
            loaderSuperview?.addSubview(self)
        }
    }
    open func stopAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isHidden = false
            self.isAnimating = false
            self.removeFromSuperview()
            self.layer.removeAllAnimations()
        }
     }
    
    internal func setupView() {
        
        guard let window = UIApplication.shared.delegate?.window else { return }
        guard let mainWindow = window else {return}
        
        self.frame = mainWindow.frame
        self.center = CGPoint(x: mainWindow.bounds.midX, y: mainWindow.bounds.midY)
        
        mainWindow.addSubview(self)
        
        self.loaderSuperview = mainWindow
        self.loaderView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width/2 - 50, height: frame.width/2 - 50)
        self.loaderView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        self.loaderView.clipsToBounds = true
        self.loaderView.layer.cornerRadius = 10
        self.loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.isHidden = true
        self.loaderText.frame = CGRect(x: 0, y: self.loaderView.frame.size.height - 50, width: self.loaderView.frame.size.width, height: 50)
        self.loaderText.font = UIFont(name: "Ariel", size: 14)
        self.loaderText.textAlignment = .center
        self.loaderText.numberOfLines = 0
        self.loaderView.addSubview(self.loaderText)
        self.loaderText.textColor = MangoBlueColor
        self.addSubview(loaderView)
        
    }
    
}
