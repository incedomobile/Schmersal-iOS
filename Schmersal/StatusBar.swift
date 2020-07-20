//
//  StatusBar.swift
//  Schmersal
//
//  Created by Ankit on 01/06/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit
class StatusBar  {
    static let sharedInstanceOBJ = StatusBar()
    public func setStatusbarColor(v:UIView) {
    if #available(iOS 13.0, *) {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        
        let statusbarView = UIView()
        statusbarView.backgroundColor = MangoBlueColor
        v.addSubview(statusbarView)
      
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: v.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: v.topAnchor).isActive = true
        statusbarView.centerXAnchor
            .constraint(equalTo: v.centerXAnchor).isActive = true
      
    } else {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = MangoBlueColor
    }
    }
    
}
