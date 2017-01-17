//
//  Item+CoreDataClass.swift
//  DreamList
//
//  Created by Abraham Barcenas M on 1/13/17.
//  Copyright © 2017 bardev. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
}
