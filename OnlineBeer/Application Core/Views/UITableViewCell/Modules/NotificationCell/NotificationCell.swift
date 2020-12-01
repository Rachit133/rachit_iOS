//
//  NotificationCell.swift
//  Beer Connect
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var imgNotifications: UIImageView!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var lblNotificationDesctions: UILabel!
    @IBOutlet weak var viewBackNotification: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
