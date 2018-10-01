//
//  SupplysDriverTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 30/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SupplysDriverTableViewController: UITableViewController {

    var locations = [LocationModel]()
    var driverDocuments = [DocumentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        if let userId = UserDefaults.standard.object(forKey: Constants.USER_ID_KEY){
            let parameters = [Constants.ID_KEY: userId]
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_USER_LOCATIONS, parameters: parameters)
                .responseJSON{(responseData) -> Void in
                    if((responseData.result.value) != nil){
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        for i in 0...(swiftyJsonVar.count-1){
                            let id = swiftyJsonVar[i][Constants.LOCATION_NAME_KEY].intValue
                            let locationName = swiftyJsonVar[i][Constants.LOCATION_NAME_KEY1].stringValue
                            guard let location = LocationModel(id: id, locationName: locationName) else {
                                fatalError("Unable to instantiate ProductModel")
                            }
                            self.locations += [location]
                        }
                        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_DRIVER_DOCUMENTS)
                            .responseJSON{(responseData) -> Void in
                                if((responseData.result.value) != nil){
                                    let swiftyJsonVar1 = JSON(responseData.result.value!)
                                    if swiftyJsonVar1.count > 0 {
                                        for i in 0...(swiftyJsonVar1.count-1){
                                            let id = swiftyJsonVar1[i][Constants.ID_KEY].intValue
                                            let day = swiftyJsonVar1[i][Constants.DAY_KEY].stringValue
                                            let hour = swiftyJsonVar1[i][Constants.HOUR_KEY].stringValue
                                            let typeId = swiftyJsonVar1[i][Constants.TYPE_DOC_ID_KEY].intValue
                                            let status = swiftyJsonVar1[i][Constants.STATUS_KEY].intValue
                                            guard let doc = DocumentModel(header: false, day: day, id: id, hour: hour, type: "FISA DE APROVIZIONARE", typeDocId: typeId, status: status, location: "") else {
                                                fatalError("Unable to instantiate ProductModel")
                                            }
                                            //i'll use header bool to keep count of visualization of supply docs
                                            self.driverDocuments += [doc]
                                        }
                                        self.tableView.reloadData()
                                    }
                                }
                        }
                    }
            }
        }
    }

    @IBAction func onClickBack(_ sender: Any) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
            print("done")
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return driverDocuments.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverDocumentsCell", for: indexPath) as! SupplyTableViewCell
        
        cell.documentNameLabel.text = driverDocuments[indexPath.row].type
        cell.locationLabel.text = driverDocuments[indexPath.row].location
        cell.documentNumberLabel.text = "Nr. " + String(driverDocuments[indexPath.row].id!)
        cell.documentDateLabel.text = driverDocuments[indexPath.row].day
        cell.timeLabel.text = driverDocuments[indexPath.row].hour
        cell.switchDocSeen.tag = indexPath.row
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
