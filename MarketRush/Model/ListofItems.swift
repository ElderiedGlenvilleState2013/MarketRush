//z
//  ListofItems.swift
//  MarketRush
//
//  Created by Sarah Yoon on 2017. 2. 17..
//  Copyright © 2017년 Sarah Yoon. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ListofItems: Object{
    
    var items: Results<Item>!
    
    //saveItem
    func saveItem(item_title: String, item_image: String, item_mallName: String, item_price: String, item_amount: Int, item_id: String)
    {
        
        let item = Item()
        
        item.item_title = item_title
        item.item_image = item_image
        item.item_mallName = item_mallName
        item.item_price = item_price
        item.item_amount = item_amount
        item.item_id = item_id

        do {
            let realm = try? Realm()
            try realm?.write {
                realm?.add(item)
                print("ok")
            }
        } catch {
            print("realm add error")
        }
    }
    
}
