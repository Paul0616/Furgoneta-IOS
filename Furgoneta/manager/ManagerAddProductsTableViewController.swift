//
//  ManagerAddProductsTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 23/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManagerAddProductsTableViewController: UITableViewController {

    
    var docTypeId: Int?
    var products = [ProductModel]()
    var choosenProducts: [Int]?
    var documentId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    @IBAction func onSwitchProduct(_ sender: UISwitch) {
        
        if sender.isOn {
            choosenProducts!.append(products[sender.tag].id)
        } else {
            if choosenProducts!.count > 0 {
                for i in 0...(choosenProducts!.count-1) {
                    if choosenProducts![i] == products[sender.tag].id {
                        choosenProducts!.remove(at: i)
                        break
                    }
                }
            }
        }
        
        
        var hoge:[JSON] = []

        var str = ""
        if choosenProducts!.count > 0 {
            for i in 0...(choosenProducts!.count-1){
                //let newData = [Constants.PRODUCT_NAME_KEY: choosenProducts![i]]
                let jsonObject: NSMutableDictionary = NSMutableDictionary()
                jsonObject.setValue(choosenProducts![i], forKey: Constants.PRODUCT_NAME_KEY)
                let newArray = JSON(jsonObject)
                str += "{\"" + Constants.PRODUCT_NAME_KEY + "\":" + String(choosenProducts![i]) + "},"
                hoge += [newArray]
            }
        }
        str = "[" + str.dropLast() + "]"
        print(str)
        let param = [Constants.ID_KEY: documentId!, Constants.PRODUCT_NAME_KEY: str] as [String : Any]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_LIST_OF_PRODUCTS, parameters: param as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                }
        }
//        do{
//            let data = try JSONSerialization.data(withJSONObject: hoge, options: [])
//            let str = String(data: hoge.rawData(), encoding: .utf8)
//            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//            let param = [Constants.ID_KEY: documentId!, Constants.PRODUCT_NAME_KEY: string!] as [String : Any]
//            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_LIST_OF_PRODUCTS, parameters: param as Parameters)
//                .responseJSON{(responseData) -> Void in
//                    if responseData.result.value != nil {
//                    }
//            }
//        }catch{
//        }
        
        

//        let jsonData: NSData
        
//        do {
//            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
//            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//            print("json string = \(jsonString)")
//            let param = [Constants.ID_KEY: documentId!, Constants.PRODUCT_NAME_KEY: jsonString] as [String : Any]
//            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_LIST_OF_PRODUCTS, parameters: param as Parameters)
//                .responseJSON{(responseData) -> Void in
//                    if responseData.result.value != nil {
//                    }
//            }
            
//        } catch _ {
//            print ("JSON Failure")
//        }

    }
    
    func readMoreData() {
        
        //let newData: NSData = ...
        
//        if let newArray = JSON(data:newData).array {
//            self.hoge += newArray
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
        products.removeAll()
        var docType: String = ""
        switch docTypeId {
        case Constants.DOCUMENT_TYPE_SUPPLY:
            docType = "aprovizionare"
        case Constants.DOCUMENT_TYPE_CONSUMER:
            docType = "consum"
        case Constants.DOCUMENT_TYPE_INVENTORY:
            docType = "inventar"
        case .none:
            print("none")
        case .some(_):
            print("some")
        }
        let param = [Constants.TYPE_KEY: docType]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_LIST_OF_PRODUCTS, parameters: param as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    for i in 0...(swiftyJsonVar.count-1){
                        let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                        let name = swiftyJsonVar[i][Constants.PRODUCT_NAME_KEY].stringValue
                        let um = swiftyJsonVar[i][Constants.PRODUCT_UNITS_KEY].stringValue
                        guard let product = ProductModel(id: id, supply: false, expediture: false, fixture: false, productName: name, productUnit: um) else {
                            fatalError("Unable to instantiate ProductModel")
                        }
                        product.selected = (self.choosenProducts?.contains(id))!
                        self.products += [product]
                    }
                    self.tableView.reloadData()
                    // self.activityIndicator.stopAnimating()
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ManagerAddProductsTableViewCell
        
        // Configure the cell...
        cell?.productNameLabel.text = products[indexPath.row].productName
        cell?.umLabel.text = products[indexPath.row].productUnit
        cell?.selectedProductSwitch.isOn = products[indexPath.row].selected
        cell?.selectedProductSwitch.tag = indexPath.row
        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
