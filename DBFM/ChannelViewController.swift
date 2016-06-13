//
//  ChannelViewController.swift
//  DBFM
//
//  Created by Jet on 16/6/11.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit
protocol ChannelViewDelegate{
    func getChannelId(channel_id:String)
}
class ChannelViewController: UIViewController {
    @IBOutlet weak var channelTableView: UITableView!

    var delegate:ChannelViewDelegate?
    var channelData = [NSDictionary]();
    override func viewDidLoad() {
        super.viewDidLoad()

      setUP()
    }

    func setUP(){
        //１.设置channelTableView的数据源和代理
        channelTableView.dataSource = self
        channelTableView.delegate = self
        
        view.alpha = 0.8
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ChannelViewController:UITableViewDataSource,UITableViewDelegate{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath)
        //2.设置数据
        cell.textLabel?.text = channelData[indexPath.row]["name"] as?String
        //3.返回cell
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let channelId = channelData[indexPath.row]["channel_id"]!
        delegate!.getChannelId(String(channelId))
        dismissViewControllerAnimated(true, completion: nil)
    }
    //动画效果
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }

}
