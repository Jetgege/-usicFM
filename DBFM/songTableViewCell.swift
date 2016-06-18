//
//  songTableViewCell.swift
//  DBFM
//
//  Created by Jet on 16/6/11.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit

class songTableViewCell: UITableViewCell {

    /// 歌曲名
    @IBOutlet weak var songName: UILabel!
   /// 配图
    @IBOutlet weak var iconImage: UIImageView!
    /// 歌手名
    @IBOutlet weak var songerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
