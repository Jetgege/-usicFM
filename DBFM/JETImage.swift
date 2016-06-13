//
//  JETImage.swift
//  DBFM
//
//  Created by Jet on 16/6/11.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit

class JETImage: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        //设置圆角半径
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = true
        //设置边框
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
    }
    
    func startRotation() {
        //动画实例
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //初始角度
        animation.fromValue = 0.0
        //结束角度
        animation.toValue = M_PI*2
        //循环次数
        animation.repeatCount = MAXFLOAT
        //执行时间
        animation.duration = 15
        animation.removedOnCompletion = false
        self.layer.addAnimation(animation, forKey: nil)
    }

}
