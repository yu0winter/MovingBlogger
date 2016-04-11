//
//  UIView+Snapshot.swift
//  MovingBlogger
//
//  Created by nyl on 16/3/29.
//  Copyright © 2016年 nyl. All rights reserved.
//

import UIKit

extension UIView {
    // Make an image from the input view.
   public static func customSnapshotWithView(view: UIView) -> UIView{
    
        UIGraphicsBeginImageContext(view.bounds.size)
        //初始化上下文
        let context = UIGraphicsGetCurrentContext()
        //设置图片内容为上下文
        view.layer.renderInContext(context!)
        //获取指定上下文中信息
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //结束绘制
        UIGraphicsEndImageContext()
        
        let snapshot: UIView = UIImageView.init(image: image)
        
        snapshot.layer.masksToBounds = true
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4

        return snapshot
    }

}
