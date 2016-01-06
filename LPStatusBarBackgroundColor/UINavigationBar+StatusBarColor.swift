//
//  UINavigationBar+StatusBarColor.swift
//
//  Created by litt1e-p on 16/1/6.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit
import ObjectiveC

extension UINavigationBar {
    
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UINavigationBar.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("layoutSubviews")
            let swizzledSelector = Selector("swizzled_layoutSubviews")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    func swizzled_layoutSubviews() {
        self.swizzled_layoutSubviews()
        if let statusBarBackgroundColor = self.statusBarBackgroundColor {
            let backgroundClass: AnyClass = NSClassFromString("_UINavigationBarBackground")!
            let statusBarBackgroundClass: AnyClass = NSClassFromString("_UIBarBackgroundTopCurtainView")!
            for aSubView: UIView in self.subviews {
                if aSubView.isKindOfClass(backgroundClass) {
                    aSubView.backgroundColor = UIColor.clearColor()
                    for aaSubView: UIView in aSubView.subviews {
                        if aaSubView.isKindOfClass(statusBarBackgroundClass) {
                            aaSubView.backgroundColor = statusBarBackgroundColor.colorWithAlphaComponent(1)
                        }
                    }
                }
            }
        }
    }
    
    private struct AssociatedKeys {
        static var UINavigationBarStatusBarBgColorRef = "UINavigationBarStatusBarBgColorRef"
    }
    
    var statusBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UINavigationBarStatusBarBgColorRef) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.UINavigationBarStatusBarBgColorRef, newValue as UIColor?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.setNeedsLayout()
        }
    }
}
