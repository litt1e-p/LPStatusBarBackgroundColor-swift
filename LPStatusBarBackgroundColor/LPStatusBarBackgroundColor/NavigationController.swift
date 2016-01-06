//
//  NavigationController.swift
//  LPStatusBarBackgroundColor
//
//  Created by litt1e-p on 16/1/6.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.statusBarBackgroundColor = UIColor.blackColor()
        
        let barSize: CGSize = CGSizeMake(self.navigationBar.frame.size.width, 44)
        self.navigationBar.setBackgroundImage(self.imageWithColor(UIColor.purpleColor(), andSize: barSize), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func imageWithColor(color: UIColor, var andSize imageSize: CGSize) -> UIImage {
        if CGSizeEqualToSize(imageSize, CGSizeZero) {
            imageSize = CGSizeMake(1, 1)
        }
        let rect: CGRect = CGRectMake(0, 0, imageSize.width, imageSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
