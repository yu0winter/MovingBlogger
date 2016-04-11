//
//  ViewController.swift
//  MovingBlogger
//
//  Created by nyl on 16/3/29.
//  Copyright © 2016年 nyl. All rights reserved.
//


import UIKit
import SnapKit
import FDStackView

class ViewController: UIViewController {
    // MARK: -
    // MARK: Custom Accessors 自定义属性
    var containerView = UIScrollView.init()
    lazy var stackView: UIStackView = {
        let _stackView = UIStackView.init()
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.axis = .Vertical
        _stackView.distribution = .Fill
        _stackView.alignment = .Fill
        _stackView.spacing = 10.0
        return _stackView
    }()
 
    lazy var longPress: UILongPressGestureRecognizer = {
        let _longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGestureRecognized))
        return _longPress
    }()
    var scrollTopTimer: NSTimer?
    var scrollDownTimer: NSTimer?
    
    // MARK: -
    // MARK: LifeCycle 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载子视图
        self.addSubViews()
        //设定布局约束
        self.layoutPageSubViews()
        //展示测试数据
        self.testWithDemoViews()
    }

    func addSubViews() {
        view.addSubview(containerView)
    
        containerView.addSubview(stackView)
        
        view.backgroundColor = UIColor.init(white: 1, alpha: 1)
        containerView.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        stackView.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        stackView.addGestureRecognizer(longPress)
    }
    func layoutPageSubViews() {
        containerView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
        
        stackView.snp_makeConstraints { (make) in
            make.top.equalTo(containerView).offset(20);
            make.left.equalTo(containerView).offset(20);
            make.width.equalTo(containerView).offset(-40);
            make.bottom.equalTo(containerView).offset(-20);
        }
    }
    
    // MARK: -
    // MARK: Protocol Conformance 遵循协议
    
    // MARK: -
    // MARK: Delegate Realization 实现委托方法
    
    // MARK: -
    // MARK: Event Response 事件响应
    var sourceView: UIView?
    var snapshot: UIView?
    var sourceIndex: Int?
    
    func longPressGestureRecognized(longPress: UILongPressGestureRecognizer){
        
        let state = longPress.state
        let locationInView = longPress.locationInView(self.view)
        let locationInContainView = longPress.locationInView(self.containerView)
        let locationInStackView = longPress.locationInView(self.stackView)
        
        switch state {
        case .Began:
            sourceIndex = stackView.indexForPressBeginAtPoint(locationInStackView)
            if sourceIndex! >= 0 {
                sourceView = stackView.arrangedSubviews[sourceIndex!]
                // Take a snapshot of the selected row using helper method.
                snapshot = UIView.customSnapshotWithView(sourceView!)
                snapshot!.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
                 // Add the snapshot as subview, centered at cell's center...
                containerView .addSubview(snapshot!)
                snapshot!.center = locationInContainView

                UIView.animateWithDuration(0.25,animations: {
                    var scale: CGFloat = 0.5
                    let maxHeight = SCREEN_WIDTH - 40
                    if self.sourceView?.frame.size.height > maxHeight {
                        scale = maxHeight/self.sourceView!.frame.size.height
                    }
                    self.snapshot?.transform = CGAffineTransformMakeScale(scale, scale)
                    self.snapshot?.alpha = 0.98
                    // ... hide the row.
                    self.sourceView?.alpha = 0.0
                    
                },
                completion: { (finished) in
                    
                })
            }
            break
        case .Changed:
            snapshot!.center = locationInContainView
            let index = stackView.indexForMoveFromSourceIndex(sourceIndex!, point: locationInStackView)
            if index != sourceIndex! {
                print("Changed from \(sourceIndex!) to \(index)")
                if IOS9_LATER {
                    stackView.insertArrangedSubview(sourceView!, atIndex: index)
                }else{
                    self.stackView.removeArrangedSubview(sourceView!)
                    self.stackView.insertArrangedSubview(sourceView!, atIndex: index)
                }
                sourceIndex = index
            }
            //stackView 内容向下滑动
            if (locationInView.y - 64 < 100) && (locationInStackView.y > 100) {
                
                if scrollTopTimer == nil {
                    self.invaildateTimer()
                    self.scrollTopTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(scrollDown), userInfo: snapshot, repeats: true)
                    NSRunLoop.currentRunLoop().addTimer(self.scrollTopTimer!, forMode: NSRunLoopCommonModes)
                }
            }
            //stackView 内容向上滑动
            else if (self.view.frame.size.height - locationInView.y < 100)
                && (self.stackView.frame.size.height - locationInStackView.y > 100) {
                if scrollDownTimer == nil {
                    self.invaildateTimer()
                    self.scrollDownTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(scrollUp), userInfo: snapshot, repeats: true)
                    NSRunLoop.currentRunLoop().addTimer(self.scrollDownTimer!, forMode: NSRunLoopCommonModes)
                }
            }
            else{
                self.invaildateTimer()
            }
            break
        default:
            let tempView = sourceView!
            UIView.animateWithDuration(0.25, animations: { 
                self.snapshot?.transform = CGAffineTransformIdentity
                self.snapshot?.alpha = 0.0
                tempView.alpha = 1.0
                }, completion: { (finished) in
                    self.sourceIndex = nil
                    self.snapshot?.removeFromSuperview()
                    self.snapshot = nil
                    self.invaildateTimer()
            })
            break
        }
    }
    
    func scrollUp(timer: NSTimer) {
     print("向上移动...")
        self.stackViewScrollWith(+5, snapShotView: timer.userInfo as? UIView);
    }
    func scrollDown(timer: NSTimer) {
     print("向下移动...")
        self.stackViewScrollWith(-5, snapShotView: timer.userInfo as? UIView);
    }
    func stackViewScrollWith(distance: CGFloat,snapShotView: UIView?) {
        var contentOffset = containerView.contentOffset
        contentOffset.y += distance
        self.containerView.contentOffset = contentOffset
        
        if (snapshot != nil) {
            var center = snapshot!.center
            center.y += distance
            snapshot!.center = center
        }
    }
    
    func invaildateTimer() {
        if self.scrollTopTimer != nil {
            self.scrollTopTimer!.invalidate()
            self.scrollTopTimer = nil
        }
        if self.scrollDownTimer != nil {
            self.scrollDownTimer!.invalidate()
            self.scrollDownTimer = nil;
        }
    }
    // MARK: -
    // MARK: Custom Method    自定义方法
    func testWithDemoViews() {
        
        let str = "猴年大吉！\n Happy new Year!\n";
        var label:UILabel!
        for i in 0...16 {
            label = UILabel.init()
            label.text = str.stringByAppendingString("\(i+1)")
            label.textColor = UIColor.init(white: 0, alpha: 0.66);
            label.numberOfLines = 0;
            label.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
            stackView.addArrangedSubview(label)
        }
    }
}

