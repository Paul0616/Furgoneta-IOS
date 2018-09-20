//
//  AddProductsTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 09/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AddProductsTableViewController: UITableViewController {

    var products = [ProductModel]()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 135
        tableView.allowsSelection = false
        
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func delButtonTapped(_ sender: UIButton) {
        let id = products[sender.tag].id
        let param = [Constants.ID_KEY: id]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_DELETE_PRODUCT, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    self.loadData()
                }
        }
    }
    
    @IBAction func supplyChanged(_ sender: UISwitch) {
            let value = sender.isOn ? 1 : 0
             let id = products[sender.tag].id
            let param = [Constants.SUPPLY_KEY: value, Constants.ID_KEY: id]
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_CHECK_PRODUCT, parameters: param)
                .responseJSON{(responseData) -> Void in
                    if responseData.result.value != nil {
                        self.products[sender.tag].supply = sender.isOn
                        self.tableView.reloadData()
                    }
                }
    }
    
    @IBAction func fixtureChanged(_ sender: UISwitch) {
        let value = sender.isOn ? 1 : 0
        let id = products[sender.tag].id
        let param = [Constants.FIXTURE_KEY: value, Constants.ID_KEY: id]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_CHECK_PRODUCT, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    self.products[sender.tag].fixture = sender.isOn
                    self.tableView.reloadData()
                }
        }
    }
    
    @IBAction func expeditureChanged(_ sender: UISwitch) {
        let value = sender.isOn ? 1 : 0
         let id = products[sender.tag].id
        let param = [Constants.EXPEDITURE_KEY: value, Constants.ID_KEY: id]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_CHECK_PRODUCT, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    self.products[sender.tag].expediture = sender.isOn
                    self.tableView.reloadData()
                }
        }
    }
    
    @IBAction func addProductBarButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func backtapped(_ sender: UIBarButtonItem) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func loadData(){
        products.removeAll()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_ALL_PRODUCTS)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    for i in 0...(swiftyJsonVar.count-1){
                        let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                        let supply = swiftyJsonVar[i][Constants.SUPPLY_KEY].intValue == 1 ? true : false
                        let expediture = swiftyJsonVar[i][Constants.EXPEDITURE_KEY].intValue == 1 ? true : false
                        let fixture = swiftyJsonVar[i][Constants.FIXTURE_KEY].intValue == 1 ? true : false
                        let productName = swiftyJsonVar[i][Constants.PRODUCT_NAME_KEY].stringValue
                        let productUnit = swiftyJsonVar[i][Constants.PRODUCT_UNITS_KEY].stringValue
                        guard let product = ProductModel(id: id, supply: supply, expediture: expediture, fixture: fixture, productName: productName, productUnit: productUnit) else {
                            fatalError("Unable to instantiate ProductModel")
                        }
                        self.products += [product]
                    }
                    self.tableView.reloadData()
                    //self.activityIndicator.stopAnimating()
                }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        cell.supplySwitch.setOn(products[indexPath.row].supply, animated: true)
        cell.supplySwitch.tag = indexPath.row
        
        cell.expeditureSwitch.setOn(products[indexPath.row].expediture, animated: true)
        cell.expeditureSwitch.tag = indexPath.row
        
        cell.fixtureSwitch.setOn(products[indexPath.row].fixture, animated: true)
        cell.fixtureSwitch.tag = indexPath.row
        
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.unitsProductLabel.text = products[indexPath.row].productUnit
        cell.editButton.tag = indexPath.row
        cell.delButton.tag = indexPath.row
        // Configure the cell...

        return cell
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

   
    // MARK: - Navigation
     @IBAction func unwindFromProduct(segue: UIStoryboardSegue) {
     
        if let sourceViewController = segue.source as? ProductModalViewController,
            let productName = sourceViewController.productNameTextField.text,
            let productUnits = sourceViewController.productUnitsTextField.text
        {
            
            if sourceViewController.index != nil {
                let param = [Constants.PRODUCT_NAME_KEY: productName, Constants.PRODUCT_UNITS_KEY: productUnits, Constants.ID_KEY: sourceViewController.index!] as [String : Any]
                Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_PRODUCT, parameters: param)
                    .responseJSON{(responseData) -> Void in
                        if responseData.result.value != nil {
                            self.loadData()
                        }
                }
                
            } else {
                let param = [Constants.PRODUCT_NAME_KEY: productName, Constants.PRODUCT_UNITS_KEY: productUnits]
                Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_PRODUCT, parameters: param)
                    .responseJSON{(responseData) -> Void in
                        if responseData.result.value != nil {
                            self.loadData()
                        }
                }
            }
           
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
            
        case "editProduct":
            guard let productModalViewController = segue.destination as? ProductModalViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEditBtn = sender as? UIButton else{
                fatalError("Unexpeted sender: \(String(describing: sender))")
            }
            
            let selectedProductName = products[selectedEditBtn.tag].productName
             let selectedProductUnits = products[selectedEditBtn.tag].productUnit
            productModalViewController.productName = selectedProductName
            productModalViewController.productUnits = selectedProductUnits
            productModalViewController.index = products[selectedEditBtn.tag].id
        case "addProduct":
           print("add product")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

}
