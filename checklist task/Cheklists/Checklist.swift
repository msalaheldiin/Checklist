//
//  Checklist.swift
//  Cheklists
//  Copyright © 2018 Mahmoud. All rights reserved.

// Moldel For creating New Checklist
import UIKit

class Checklist: NSObject,NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName : String
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
 
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    //counting completed items
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1 }
        return count
    }
    
   
}

