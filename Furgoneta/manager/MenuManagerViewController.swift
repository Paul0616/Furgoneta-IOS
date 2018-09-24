//
//  MenuManagerViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 24/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuManagerViewController: UIViewController {

    @IBOutlet weak var addSupplyButton: UIButton!
    @IBOutlet weak var addConsumerButton: UIButton!
    @IBOutlet weak var addEndDayButton: UIButton!
    @IBOutlet weak var addInventoryButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddSupply(_ sender: UIButton) {
        performSegue(withIdentifier: "addDocuments", sender: sender)
    }
    @IBAction func onAddConsumer(_ sender: UIButton) {
        performSegue(withIdentifier: "addDocuments", sender: sender)
    }
    @IBAction func onAddEndday(_ sender: UIButton) {
    }
    @IBAction func onAddInventory(_ sender: UIButton) {
        performSegue(withIdentifier: "addDocuments", sender: sender)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
        let backgroundImage = UIImage(named: "app_background")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        addSupplyButton.layer.cornerRadius = 20
        addConsumerButton.layer.cornerRadius = 20
        addEndDayButton.layer.cornerRadius = 20
        addInventoryButton.layer.cornerRadius = 20
        addSupplyButton.titleLabel?.textAlignment = NSTextAlignment.center
        addConsumerButton.titleLabel?.textAlignment = NSTextAlignment.center
        addEndDayButton.titleLabel?.textAlignment = NSTextAlignment.center
        addInventoryButton.titleLabel?.textAlignment = NSTextAlignment.center
        activityIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_IS_DOC_AVAILABLE)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    let resultSupply = swiftyJsonVar[0][Constants.RESULT_KEY].boolValue
                    let resultConsumer = swiftyJsonVar[1][Constants.RESULT_KEY].boolValue
                    let resultInventory = swiftyJsonVar[2][Constants.RESULT_KEY].boolValue
                    let resultEndDay = swiftyJsonVar[3][Constants.RESULT_KEY].boolValue
                    self.addSupplyButton.isEnabled = resultSupply
                    self.addConsumerButton.isEnabled = resultConsumer
                    self.addInventoryButton.isEnabled = resultInventory
                    self.addEndDayButton.isEnabled = resultEndDay
                    self.activityIndicator.stopAnimating()
                }
        }
    }
    
    @IBAction func onClickBackbutton(_ sender: Any) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
        if  segue.identifier == "addDocuments",
        let destination = segue.destination as? DocumentViewController,
        let button = sender as? UIButton
        {
            switch button.tag {
            case 0:
                destination.documentTypeId = Constants.DOCUMENT_TYPE_SUPPLY
                destination.docType = "FISA DE APROVIZIONARE"
            case 1:
                destination.documentTypeId = Constants.DOCUMENT_TYPE_CONSUMER
                destination.docType = "BON DE CONSUM"
            case 2:
                destination.documentTypeId = Constants.DOCUMENT_TYPE_INVENTORY
                destination.docType = "INVENTAR"
            default:
                print("unknown document type")
            }
            destination.addAction = true
            destination.finished = false
        }
    
    }
}
