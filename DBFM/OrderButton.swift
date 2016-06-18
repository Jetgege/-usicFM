//
//  OrderButton.swift
//  DBFM
//
//  Created by Jet on 16/6/12.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit

class OrderButton: UIButton {
    
    var order:Int = 1
    let order1 = UIImage(named: "order1")
    let order2 = UIImage(named: "order2")
    let order3 = UIImage(named: "order3")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(OrderButton.selectMode), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /**选择的模式*/
    func selectMode() {
        order += 1
        if order == 1 {
            self.setImage(order1, forState: UIControlState.Normal)
        }else if order == 2{
            self.setImage(order2, forState: UIControlState.Normal)
        }else if order == 3{
            self.setImage(order3, forState: UIControlState.Normal)
        }else if order > 3{
            order = 1
            self.setImage(order1, forState: UIControlState.Normal)
           
        }
        
    }
}
