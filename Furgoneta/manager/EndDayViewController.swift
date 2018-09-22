//
//  EndDayViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 21/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EndDayViewController: UIViewController {

    @IBOutlet weak var monetaryButton: UIButton!
    @IBOutlet weak var cashTextField: DesignableUItextField!
    @IBOutlet weak var cardTextField: DesignableUItextField!
    @IBOutlet weak var soldTextField: DesignableUItextField!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var documentDateLabel: UILabel!
    
    var finished: Bool = false
    var documentId: Int?
    var documentDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monetaryButton.layer.cornerRadius = 20
        documentIdLabel.text = "Nr. " + String(documentId!)
        documentDateLabel.text = "din " + documentDate!
        // Do any additional setup after loading the view.
        
        
        cashTextField.isEnabled = !(finished)
        cardTextField.isEnabled = !(finished)
        soldTextField.isEnabled = !(finished)
        
        let param = [Constants.ID_KEY: documentId] as [String: Int?]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_FISA_INCHIDERE, parameters: param as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    let cash: Double = swiftyJsonVar[0][Constants.CASH_KEY].doubleValue
                    let card: Double = swiftyJsonVar[0][Constants.CARD_KEY].doubleValue
                    let sold: Double = swiftyJsonVar[0][Constants.SOLD_KEY].doubleValue
                    self.cashTextField.text = String(cash)
                    self.cardTextField.text = String(card)
                    self.soldTextField.text = String(sold)
                }
        }
        
    }
    
    @IBAction func onClickMonetary(_ sender: Any) {
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showMonetary",
            let destination = segue.destination as? MonetaryViewController
        {
            destination.documentId = documentId
            
        }
    }
    

}
