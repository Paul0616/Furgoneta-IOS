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
    var documentItems = [DocumentItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData(){
        if documentId != nil && documentId != 0 {
            documentItems.removeAll()
            //     activityIndicator.startAnimating()
            let param = [Constants.ID_KEY: documentId] as [String: Int?]
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_DOCUMENT_PRODUCTS, parameters: param as Parameters)
                .responseJSON{(responseData) -> Void in
                    if responseData.result.value != nil {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        for i in 0...(swiftyJsonVar.count-1){
                            let product = swiftyJsonVar[i][Constants.PRODUCT_NAME_KEY].stringValue
                            let um = swiftyJsonVar[i][Constants.PRODUCT_UNITS_KEY].stringValue
                            let quantity = swiftyJsonVar[i][Constants.QUANTITY_KEY].doubleValue
                            let motivation = swiftyJsonVar[i][Constants.MOTIVATION_KEY].stringValue
                            guard let document = DocumentItem(product: product, um: um, quantity: quantity, motivation: motivation) else {
                                                                fatalError("Unable to instantiate ProductModel")
                            }
                            self.documentItems += [document]
                        }
                        self.documentTableView.reloadData()
                        // self.activityIndicator.stopAnimating()
                    }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if documentTypeId == 1 {
            guard let cell = documentTableView.dequeueReusableCell(withIdentifier: "SupplyCell", for: indexPath) as? SupplyDocumentTableViewCell else {
                fatalError("The dequeued cell is not an instance of SupplyDocumentTableViewCell.")
            }
            return cell
            //supplyCell.dayDateLabel.text = documents[indexPath.row].day
        } else if documentTypeId == 2 {
            guard let cell = documentTableView.dequeueReusableCell(withIdentifier: "ConsumerBillCell", for: indexPath) as? ConsumerTableViewCell else {
                fatalError("The dequeued cell is not an instance of ConsumerTableViewCell.")
            }
            return cell
            //supplyCell.dayDateLabel.text = documents[indexPath.row].day
        } else {
            guard let cell = documentTableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as? InventoryTableViewCell else {
                fatalError("The dequeued cell is not an instance of InventoryTableViewCell.")
            }
            return cell
            //supplyCell.dayDateLabel.text = documents[indexPath.row].day
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
