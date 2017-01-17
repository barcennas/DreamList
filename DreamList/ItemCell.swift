//
//  ItemCell.swift
//  DreamList
//
//  Created by Abraham Barcenas M on 1/13/17.
//  Copyright © 2017 bardev. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var thumbNail: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var details: UILabel!
    
    
    func configureCell(item: Item){
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumbNail.image = item.toImage?.image as? UIImage
    }
}
