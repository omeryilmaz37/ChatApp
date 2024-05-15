//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Ömer Yılmaz on 6.05.2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

// MessageCell sınıfını tanımla ve UITableViewCell sınıfından türet
class MessageCell: UITableViewCell {

    // IBOutlet ile arayüz öğelerini tanımla
    @IBOutlet weak var messageBubble: UIView! // Mesaj balonunu temsil eden görünüm
    @IBOutlet weak var label: UILabel! // Mesaj metnini gösteren etiket
    @IBOutlet weak var rightImageView: UIImageView! // Sağ taraftaki kullanıcı avatarını gösteren görüntü
    @IBOutlet weak var leftImageView: UIImageView! // Sol taraftaki kullanıcı avatarını gösteren görüntü
    
    // Hücre öğeleri yüklenirken çağrılan metod
    override func awakeFromNib() {
        super.awakeFromNib()
        // Mesaj balonunun köşelerini yuvarla
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    // Hücre seçildiğinde çağrılan metod
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Seçili duruma göre görünümü yapılandır
        // (Bu uygulamada herhangi bir işlevsellik eklenmemiştir)
    }
}
