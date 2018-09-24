//
//  DocumentViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 19/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DocumentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var documentTableView: UITableView!
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var documentDatelabel: UILabel!
    
    var documentTypeId: Int?
    var docType: String?
    var documentId: Int?
    var documentDate: String?
    var finished: Bool?
    var addAction: Bool = false
    var documentItems = [DocumentItem]()
    var choosenProducts: [Int] = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //documentTableView.dataSource = self
        documentTypeLabel.text = docType?.uppercased()
        if !addAction {
            documentIdLabel.text = "Nr. " + String(documentId!)
            documentDatelabel.text = " din " + documentDate!
        }
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, add]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.toolbar.isTranslucent = true
        navigationController?.toolbar.barTintColor = UIColor.orange
        navigationController?.toolbar.tintColor = UIColor.darkGray
        navigationController?.setToolbarHidden(finished!, animated: true)
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addProductTapped(){
      performSegue(withIdentifier: "addProducts", sender: self)
    }
    
    private func loadData(){
        if documentId != nil && documentId != 0 {
            documentItems.removeAll()
            choosenProducts.removeAll()
            //     activityIndicator.startAnimating()
            let param = [Constants.ID_KEY: documentId] as [String: Int?]
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_DOCUMENT_PRODUCTS, parameters: param as Parameters)
                .responseJSON{(responseData) -> Void in
                    if responseData.result.value != nil {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        if swiftyJsonVar.count > 0 {
                            for i in 0...(swiftyJsonVar.count-1){
                                let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                                let product = swiftyJsonVar[i][Constants.PRODUCT_NAME_KEY].stringValue
                                let um = swiftyJsonVar[i][Constants.PRODUCT_UNITS_KEY].stringValue
                                let quantity = swiftyJsonVar[i][Constants.QUANTITY_KEY].doubleValue
                                let motivation = swiftyJsonVar[i][Constants.MOTIVATION_KEY].stringValue
                                self.choosenProducts.append(id)
                                guard let document = DocumentItem(product: product, um: um, quantity: quantity, motivation: motivation) else {
                                                                    fatalError("Unable to instantiate ProductModel")
                                }
                                self.documentItems += [document]
                            }
                        }
                        self.documentTableView.reloadData()
                        // self.activityIndicator.stopAnimating()
                    }
            }
        } else {
            //print("Adaugare")
            let preferences = UserDefaults.standard
            let param = [Constants.TYPE_KEY: documentTypeId, Constants.ID_KEY: preferences.object(forKey: Constants.USER_ID_KEY), Constants.LOCATION_NAME_KEY: preferences.object(forKey: Constants.LOCATION_NAME_KEY+Constants.ID_KEY)]
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_NEW_DOCUMENT, parameters: param as Parameters)
                .responseJSON{(responseData) -> Void in
                    if responseData.result.value != nil {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        self.documentId = swiftyJsonVar[0][Constants.ID_KEY].intValue
                        self.addAction = false
                        self.documentIdLabel.text = "Nr. " + String(self.documentId!)
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd.MM.yyyy"
                        self.documentDate = formatter.string(from: date)
                        self.documentDatelabel.text = " din " + self.documentDate!
                    }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = documentTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailDocumentTableViewCell
        cell1?.product.text = documentItems[indexPath.row].product
        cell1?.quantity.text = String(documentItems[indexPath.row].quantity)
        cell1?.um.text = documentItems[indexPath.row].um
         cell1?.motivation.text = documentItems[indexPath.row].motivation
        cell1?.motivation.isHidden = !(documentTypeId == Constants.DOCUMENT_TYPE_CONSUMER)
        self.finished! ? (cell1?.accessoryType = .checkmark) : (cell1?.accessoryType = .disclosureIndicator)
        return cell1!
        //supplyCell.dayDateLabel.text = documents[indexPath.row].day
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "modalyEditQuantity", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "addProducts",
            let destination = segue.destination as? ManagerAddProductsTableViewController
        {
            destination.docTypeId = documentTypeId
            destination.choosenProducts = choosenProducts
            destination.documentId = documentId
        }
        if  segue.identifier == "modalyEditQuantity",
            let destination = segue.destination as? EditProductViewController,
            let index = documentTableView.indexPathForSelectedRow
        {
            destination.documentTypeId = documentTypeId
            destination.quantity = documentItems[index.row].quantity
            destination.productName = documentItems[index.row].product
        }
        
        if  segue.identifier == "modalyEditQtyAndMotiv",
            let destination = segue.destination as? ManagerAddProductsTableViewController
        {
            destination.docTypeId = documentTypeId
            destination.choosenProducts = choosenProducts
            destination.documentId = documentId
        }
    }
    

}
