//
//  StackView+Index.swift
//  MovingBlogger
//
//  Created by nyl on 16/3/29.
//  Copyright © 2016年 nyl. All rights reserved.
//


import UIKit
import FDStackView

@available(iOS 9.0, *)
extension UIStackView {
    public func indexForMoveFromSourceIndex(sourceIndex: NSInteger,point: CGPoint) -> NSInteger {
        
        var index = sourceIndex
        //向上移动时
        if sourceIndex > 0 {
            let lastView = self.arrangedSubviews[sourceIndex - 1]
            if point.y < lastView.center.y {
                index = self.arrangedSubviews.indexOf(lastView)!
            }
        }
        //向下移动时
        if sourceIndex < self.arrangedSubviews.count - 1 {
            let nextView = self.arrangedSubviews[sourceIndex + 1]
            if point.y > nextView.center.y {
                index = self.arrangedSubviews.indexOf(nextView)!
            }
        }
        assert(index < self.arrangedSubviews.count, "移动的目的位置怎么超出数组了？？")
        
        return index
    }
    public func indexForPressBeginAtPoint(point: CGPoint) -> NSInteger{
        
        var index = 0
        for view in self.arrangedSubviews {
            let minY = CGRectGetMinY(view.frame)
            let maxY = CGRectGetMaxY(view.frame)
            
            if point.y > minY && point.y < maxY {
                index = self.arrangedSubviews.indexOf(view)!
                return index
            }
        }
        
        return index
    }
}


@available(iOS 6.0, *)
extension FDStackView {
    public func indexForMoveFromSourceIndex(sourceIndex: NSInteger,point: CGPoint) -> NSInteger {
        
        var index = sourceIndex
        //向上移动时
        if sourceIndex > 0 {
            let lastView = self.arrangedSubviews[sourceIndex - 1]
            if point.y < lastView.center.y {
                index = self.arrangedSubviews.indexOf(lastView)!
            }
        }
        //向下移动时
        if sourceIndex < self.arrangedSubviews.count - 1 {
            let nextView = self.arrangedSubviews[sourceIndex + 1]
            if point.y > nextView.center.y {
                index = self.arrangedSubviews.indexOf(nextView)!
            }
        }
        assert(index < self.arrangedSubviews.count, "移动的目的位置怎么超出数组了？？")
        
        return index
    }
    public func indexForPressBeginAtPoint(point: CGPoint) -> NSInteger{
        
        var index = 0
        for view in self.arrangedSubviews {
            let minY = CGRectGetMinY(view.frame)
            let maxY = CGRectGetMaxY(view.frame)
            
            if point.y > minY && point.y < maxY {
                index = self.arrangedSubviews.indexOf(view)!
                return index
            }
        }
        
        return index
    }
}
