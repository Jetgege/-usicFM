//
//  HTTPController.swift
//  DBFM
//
//  Created by Jet on 16/6/11.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//定义协议
protocol HTTPControllerDelegate{

    //定义代理方法
    func didRecieveResult(result:AnyObject)
}
class HTTPController: NSObject {

    //定义一个代理
    var delegate:HTTPControllerDelegate?
    //接收网址，回调代理的方法传递数据
    func onSearch(url:String) {
        Alamofire.request(.GET,url).responseJSON { (response) in
//            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
     let jsonResult = try! NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            self.delegate?.didRecieveResult(jsonResult)
        }
    }

}

