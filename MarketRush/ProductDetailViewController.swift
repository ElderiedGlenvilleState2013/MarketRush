//
//  ProductDetailViewController.swift
//  MarketRush
//
//  Created by Sarah Yoon on 2017. 2. 16..
//  Copyright © 2017년 Sarah Yoon. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var item: Item!
        //var items: Results<Item>!
    
    var list = ["상품이름", "가격", "쇼핑몰이름"]
    var section = ["1", "2"]

    //button outlet
    @IBOutlet weak var saveItemtoListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 239/255, green: 240/255, blue: 241/255, alpha: 0.4)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //4
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailImageCell") as! DetailImageTableViewCell
            if let url = NSURL(string:item.item_image!){
                cell.productimage.af_setImage(withURL: url as URL)
            }
            return cell
        }
        else{ // row == 1
            
            //let row = self.list[indexPath.row] //2번째 row부터
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailDescriptionCell") as! DetailDescriptionTableViewCell
            
            let string = item?.item_title?.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            cell.productName.text = string
            
            cell.price.text = "가격"
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let priceInt = Int(item.item_price!)
            cell.productPrice.text = numberFormatter.string(from: NSNumber(value: priceInt!))

            cell.mallName.text = "쇼핑몰"
            cell.productMall.text = item.item_mallName

            return cell
            
        }
    }
    
    @IBAction func saveItemToList(_ sender: Any) {
        //알림창 3초후에 사라지기로 변경!
        
        //장바구니에 새로 담은 제품일 경우
        if ((ifIdExists(findId: item.item_id!)) == nil){
            
            ListofItems().saveItem(item_title: item.item_title!, item_image: item.item_image!, item_mallName: item.item_mallName!, item_price: item.item_price!, item_amount: item.item_amount, item_id: item.item_id!)
            
            let string = item?.item_title?.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            
            let alertController = UIAlertController(title: "상품이 장바구니에 담겼습니다.", message: string, preferredStyle: UIAlertControllerStyle.alert)
            
            // Background color.
            let backView = alertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            
            // Change Title With Color and Font:
            let myTitle  = "상품이 장바구니에 담겼습니다."
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myTitle as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 16.0)!])
            alertController.setValue(myMutableString, forKey: "attributedTitle")
            
            // Change Message With Color and Font
            let message  = string
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string: message! as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!])
            messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 55/255, green: 142/255, blue: 109/255, alpha: 1.0), range: NSRange(location:0,length:(message?.characters.count)!))
            
            alertController.setValue(messageMutableString, forKey: "attributedMessage")
            
            // Action.
            let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            
        }
            
            //이미 장바구니에 담은 제품일 경우
        else{
            
            saveItemtoListButton.titleLabel?.textColor = UIColor(red: 55, green: 142, blue: 109, alpha: 0.3)
            
            let alertController: UIAlertController = UIAlertController(title: "", message: "이미 선택하신 제품입니다.", preferredStyle: .alert)
            let action_cancel = UIAlertAction.init(title: "계속 쇼핑하기", style:.cancel){
                (UIAlertAction) -> Void in }
            
            alertController.addAction(action_cancel)
            present(alertController, animated: true, completion: nil)
        }

    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        
//    
//    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5.0
//        
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     if indexPath.section == 0
     {
        return 400.0
        }
     if indexPath.section == 1
     {
        return 200.0
        }
     else{
        return 45.0
        }
    }
    
    //product ID 확인
    func ifIdExists(findId: String) -> Item?{
        
        let predicate = NSPredicate(format: "item_id = %@", findId)
        let realm = try? Realm()
        let object = realm?.objects(Item.self).filter(predicate).first
        if object?.item_id == findId {
            
            return object
            
        }
        return nil
    }
    

}
