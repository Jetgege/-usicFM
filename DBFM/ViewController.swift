//
//  ViewController.swift
//  DBFM
//
//  Created by Jet on 16/6/11.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import MediaPlayer
import Toast_Swift


class ViewController: UIViewController,HTTPControllerDelegate,ChannelViewDelegate{
     /// 播放模式控制按钮
    @IBOutlet weak var playModeBtn: OrderButton!
      /// 播放控制按钮
    @IBOutlet weak var playBotton: UIButton!
    
    @IBOutlet weak var tvTableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var rotaImageView: JETImage!
    
    @IBOutlet weak var progressView: UIImageView!
    
    var avPlayer:AVPlayer?
    var isplay:Bool = false
    var dataChannel = [NSDictionary]()
    var dataSong = [NSDictionary]()

    //创建网络操作类
    let eHttp = HTTPController()
    /// 播放时间
    @IBOutlet weak var timerLabel: UILabel!
    
    //记录当前播放的歌曲所以
    var currentIndex:Int = 0
    
    //记录播放是否为自动结束状态
    var autoPalyStop:Bool = true
    
    var timer:NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
    }


    // MARK: - 内部方法
    private  func onSetAudio(urlStr:String) {
        guard let url = NSURL(string:urlStr) else{
            return
        }
        let item = AVPlayerItem(URL: url)
        
        if avPlayer == nil {
            
            avPlayer = AVPlayer(playerItem: item)
            let avlayer = AVPlayerLayer(player: avPlayer)
            avlayer.frame = self.view.bounds
            self.view.layer.addSublayer(avlayer)
        }
        avPlayer?.replaceCurrentItemWithPlayerItem(item)
        avPlayer!.play()
        autoPalyStop = true
        playBotton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        timer?.invalidate()
        timerLabel.text = "00:00"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.upDataTime), userInfo:nil, repeats: true)
        
    }
    
    /**刷新时间，刷新进度条 */
    @objc private  func upDataTime(){
        
        let cmTimes = avPlayer?.currentTime()
        
        if cmTimes?.value > 0 {
            let times = Int64((cmTimes?.value)!) / Int64((cmTimes?.timescale)!)
            let ss = times % 60
            let mm = times / 60
            let mmTime:String!
            let ssTime:String!
            if mm < 10 {
                mmTime = "0\(mm)"
            }else{
                mmTime = "\(mm)"
            }
            if ss < 10 {
                ssTime = "0\(ss)"
            }else{
                ssTime = "\(ss)"
            }
            timerLabel.text = "\(mmTime):\(ssTime)"
            
            if avPlayer?.status == AVPlayerStatus.ReadyToPlay {
                let Times =  avPlayer?.currentItem?.duration
                
                let allTime = Int64((Times!.value)) / Int64((Times!.timescale))
                
                let pro = CGFloat(times) / CGFloat(allTime)
                let width = UIScreen.mainScreen().bounds.size.width*CGFloat(pro)
                progressView.frame.size.width = width
            }
            
        }
    }
    
    private func setUP(){
        //１.设置旋转效果
        rotaImageView.startRotation()
        //２.设置背景图片的模糊效果
        //2.1创建模糊对象
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        //2.2创建模糊视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = view.frame.size
        //2.3加载模糊视图
        bgImageView.addSubview(blurView)
        
        //
        tvTableView.dataSource = self
        tvTableView.delegate = self
        tvTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        //清除背景颜色
        tvTableView.backgroundColor = UIColor.clearColor()
        eHttp.delegate = self
        //获取频道数据
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        //获取频道为０的歌曲数据
        eHttp.onSearch("https://douban.fm/j/mine/playlist?type=n&channel=4&from=mainsite")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.playFinished), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
    }
    
    @objc func playFinished(){
        if autoPalyStop {
            
            switch playModeBtn.order {
            case 1:
                //顺序播放
                currentIndex += 1
                if currentIndex > dataSong.count-1 {
                    currentIndex = 0
                }
                tableView(tvTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: currentIndex, inSection: 0))
            case 2:
                //随机播放
                let index = arc4random_uniform(UInt32(dataSong.count-1))
                tableView(tvTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: Int(index), inSection: 0))
            case 3:
                //单曲循环
                tableView(tvTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: currentIndex, inSection: 0))
            default:
                return
            }
        }else{
            autoPalyStop = true
        }
    }
    
//播放控制方法
    @IBAction func isPlayBtn(sender: UIButton) {
        if !isplay {
            sender.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            avPlayer?.play()
        }else{
            sender.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            avPlayer?.pause()
        }
        isplay = !isplay
    }
    //下一首
    @IBAction func nextSong(sender: UIButton) {
        autoPalyStop = false
        currentIndex += 1
        if currentIndex > dataSong.count-1{
            currentIndex = 0
        }
        let intdxPath = NSIndexPath(forRow: currentIndex, inSection: 0)
        tableView(tvTableView, didSelectRowAtIndexPath: intdxPath)
    }
    //上一首
    @IBAction func lastSong(sender: UIButton) {
         autoPalyStop = false
        currentIndex -= 1
        if currentIndex < 0{
            currentIndex = dataSong.count-1
        }
         let intdxPath = NSIndexPath(forRow: currentIndex, inSection: 0)
        tableView(tvTableView, didSelectRowAtIndexPath: intdxPath)
    }

    @IBAction func orderPlay(sender: OrderButton) {
        
        var message:String = ""
        switch sender.order {
        case 1:
             message = "顺序播放"
        case 2:
             message = "随机播放"
        case 3:
             message = "单曲循环"
        default:  
             message = "服务器泡妞去了"
        }
        self.view.makeToast(message, duration: 0.5, position: ToastPosition.Center)
    }
   
    //缓存图片
   private func getImageCache(url:String,imageView:UIImageView){
    // 从内存\沙盒缓存中获得原图，
    let key = url
    //保存下载的文件到沙河
 
    let originalImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(key)
    if (originalImage != nil) { // 如果内存\沙盒缓存有原图，那么就直接显示原图
        imageView.image = originalImage;
    }else{
        imageView.sd_setImageWithURL(NSURL(string: url))
    }
    }
    //
    func didRecieveResult(result: AnyObject) {

       let dict = result as!NSDictionary
        if let channel = dict["channels"]{
            dataChannel = channel as![NSDictionary]
        }
        if let song = dict["song"]{
            dataSong = song as![NSDictionary]
             let index = NSIndexPath(forRow: 0, inSection: 0)
             tableView(self.tvTableView, didSelectRowAtIndexPath: index)
             self.tvTableView.reloadData()
        }
        
    }
    
    /**专场设置*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let channelCV = segue.destinationViewController as! ChannelViewController
       channelCV.channelData = self.dataChannel
       channelCV.delegate = self
        
    }

    func getChannelId(channel_id: String) {
        //获取频道的歌曲数据
        let url = "https://douban.fm/j/mine/playlist?type=n&channel=\(channel_id)&from=mainsite"
        eHttp.onSearch(url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSong.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("tvCell", forIndexPath: indexPath) as!songTableViewCell
        //清除背景颜色
        cell.backgroundColor = UIColor.clearColor()
        
        //2.设置数据
        //获取歌曲名称
        cell.songName.text = dataSong[indexPath.row]["title"]as?String
        //获取歌手名称
        cell.songerName.text = dataSong[indexPath.row]["artist"]as?String
        //设置缩略图
        let url = dataSong[indexPath.row]["picture"]as?String
        getImageCache(url!, imageView: cell.iconImage)
        //3.返回cell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         autoPalyStop = false
        currentIndex = indexPath.row
        //设置缩略图
        let url = dataSong[indexPath.row]["picture"]as?String
        getImageCache(url!, imageView: rotaImageView)
        getImageCache(url!, imageView: bgImageView)
        let mp3URL = dataSong[indexPath.row]["url"]as?String
        onSetAudio(mp3URL!)

    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5) { 
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
}

