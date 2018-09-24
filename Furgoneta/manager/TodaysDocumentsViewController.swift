//
//  TodaysDocumentsViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 23/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TodaysDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chooseLocationButton: UIButton!
    @IBOutlet weak var dropDownListLocationTableView: UITableView!
    @IBOutlet weak var documentsTableView: UITableView!
    
    var userLocations = [LocationModel]()
    var todaydocuments = [DocumentModel]()
    var locationId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownListLocationTableView.isHidden = true
       
        // Do any additional setup after loading the view.
    }
   
    @IBAction func onClickBack(_ sender: Any) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func onClickAddDocuments(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onClickChooseLocation(_ sender: Any) {
        animate(toogle: dropDownListLocationTableView.isHidden)
        
    }
    func animate(toogle: Bool){
        UIView.animate(withDuration: 0.3, animations: {
            self.dropDownListLocationTableView.isHidden = !toogle
        })
    }
    @IBAction func onClickedit(_ sender: UIButton) {
        let index = sender.tag
        if todaydocuments[index].typeDocId != Constants.DOCUMENT_TYPE_END_DAY {
            performSegue(withIdentifier: "managerDocumentShow", sender: sender)
        } else {
            performSegue(withIdentifier: "managerEndDayShow", sender: sender)
        }
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.setToolbarHidden(true, animated: true)
        userLocations.removeAll()
        todaydocuments.removeAll()
       let preferences = UserDefaults.standard
        if preferences.object(forKey: Constants.USER_ID_KEY) != nil && preferences.object(forKey: Constants.USER_ID_KEY) as! Int != 0 {
            let param = [Constants.ID_KEY: preferences.object(forKey: Constants.USER_ID_KEY)] as! [String: Int]
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_USER_LOCATIONS, parameters: param)
                .responseJSON{(responseData) -> Void in
                    if responseData.result.value != nil {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        if swiftyJsonVar.count == 1 {
                            self.chooseLocationButton.setTitle(swiftyJsonVar[0][Constants.LOCATION_NAME_KEY1].stringValue, for: .normal)
                            self.locationId = swiftyJsonVar[0][Constants.LOCATION_NAME_KEY].intValue
                            UserDefaults.standard.setValuesForKeys([Constants.LOCATION_NAME_KEY + Constants.ID_KEY: self.locationId])
                            self.loadLocationTodayDocuments(locationId: self.locationId)
                        }
                        for i in 0...(swiftyJsonVar.count-1){
                            let id = swiftyJsonVar[i][Constants.LOCATION_NAME_KEY].intValue
                            let locationName = swiftyJsonVar[i][Constants.LOCATION_NAME_KEY1].stringValue
                            guard let location = LocationModel(id: id, locationName: locationName) else {
                                fatalError("Unable to instantiate ProductModel")
                            }
                            self.userLocations += [location]
                        }
                        self.dropDownListLocationTableView.reloadData()
                    }
            }
        }
       
        
    }
    
    func loadLocationTodayDocuments(locationId: Int) {
        let preferences = UserDefaults.standard
        let param1 = [Constants.ID_KEY: preferences.object(forKey: Constants.USER_ID_KEY), Constants.LOCATION_NAME_KEY: locationId]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_TODAY_DOCUMENTS, parameters: param1 as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar1 = JSON(responseData.result.value!)
                    if swiftyJsonVar1.count > 0 {
                        for i in 0...(swiftyJsonVar1.count-1){
                            let id = swiftyJsonVar1[i][Constants.ID_KEY].intValue
                            let day = swiftyJsonVar1[i][Constants.DAY_KEY].stringValue
                            let hour = swiftyJsonVar1[i][Constants.HOUR_KEY].stringValue
                            let type = swiftyJsonVar1[i][Constants.TYPE_KEY].stringValue
                            let typeId = swiftyJsonVar1[i][Constants.TYPE_DOC_ID_KEY].intValue
                            let status = swiftyJsonVar1[i][Constants.STATUS_KEY].intValue
                            guard let doc = DocumentModel(header: false, day: day, id: id, hour: hour, type: type, typeDocId: typeId, status: status, location: "") else {
                                fatalError("Unable to instantiate ProductModel")
                            }
                            self.todaydocuments += [doc]
                        }
                    }
                    self.documentsTableView.reloadData()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int = 0
        if tableView == dropDownListLocationTableView {
            count = userLocations.count
        }
        if tableView == documentsTableView {
            count = todaydocuments.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropDownListLocationTableView {
            //var cell:UITableViewCell?
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellRoles", for: indexPath)
            cell.textLabel?.text = userLocations[indexPath.row].locationName
            return cell
        } else {
            let cell1 = (tableView.dequeueReusableCell(withIdentifier: "docCell", for: indexPath) as? TodayDocumentsTableViewCell)!
            cell1.documentTypeLabel.text = todaydocuments[indexPath.row].type
            cell1.documentDateLabel.text = todaydocuments[indexPath.row].day
            cell1.documentTimeLabel.text = todaydocuments[indexPath.row].hour
            cell1.documentIdLabel.text = String(todaydocuments[indexPath.row].id!)
            if todaydocuments[indexPath.row].status == 1 {
                cell1.changeStatusButton.isHidden = true
                cell1.deleteButton.isHidden = true
                cell1.editButton.isHidden = true
                cell1.accessoryType = .checkmark
            } else {
                cell1.changeStatusButton.isHidden = false
                cell1.deleteButton.isHidden = false
                cell1.editButton.isHidden = false
                cell1.accessoryType = .none
            }
            cell1.editButton.tag = indexPath.row
            cell1.deleteButton.tag = indexPath.row
            switch todaydocuments[indexPath.row].typeDocId {
            case Constants.DOCUMENT_TYPE_SUPPLY:
                cell1.backgroundColor = UIColor(red:0.84, green:0.88, blue:0.96, alpha:1.0)
            case Constants.DOCUMENT_TYPE_CONSUMER:
                cell1.backgroundColor = UIColor(red:0.87, green:0.90, blue:0.87, alpha:1.0)
            case Constants.DOCUMENT_TYPE_END_DAY:
                cell1.backgroundColor = UIColor(red:0.89, green:0.80, blue:0.95, alpha:1.0)
            case Constants.DOCUMENT_TYPE_INVENTORY:
                cell1.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.85, alpha:1.0)
            default:
                print("unknown document type")
                
            }
            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropDownListLocationTableView {
            locationId = userLocations[indexPath.row].id
            chooseLocationButton.setTitle("\(userLocations[indexPath.row].locationName)", for: .normal)
            animate(toogle: false)
            UserDefaults.standard.setValuesForKeys([Constants.LOCATION_NAME_KEY + Constants.ID_KEY: locationId])
            loadLocationTodayDocuments(locationId: locationId)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if  segue.identifier == "managerDocumentShow",
            let destination = segue.destination as? DocumentViewController,
            let button: UIButton = sender as? UIButton
        {
            destination.documentTypeId = todaydocuments[button.tag].typeDocId
            destination.docType = todaydocuments[button.tag].type
            destination.documentId = todaydocuments[button.tag].id
            destination.documentDate = todaydocuments[button.tag].day
            destination.finished = false
        }
        if  segue.identifier == "managerEndDayShow",
            let destination = segue.destination as? EndDayViewController,
            let button: UIButton = sender as? UIButton
        {
            destination.finished = false
            destination.documentId = todaydocuments[button.tag].id
            destination.documentDate = todaydocuments[button.tag].day
        }
    }
    

}
