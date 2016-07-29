// The MIT License (MIT)
//
// Copyright (c) 2015-2016 litt1e-p ( https://github.com/litt1e-p )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import ObjectiveC

public extension UINavigationBar
{
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UINavigationBar.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = #selector(UIView.layoutSubviews)
            let swizzledSelector = #selector(UINavigationBar.swizzled_layoutSubviews)
            
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
    
    @objc private func swizzled_layoutSubviews() {
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
    
    public var statusBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UINavigationBarStatusBarBgColorRef) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.UINavigationBarStatusBarBgColorRef, newValue as UIColor?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.setNeedsLayout()
        }
    }
}