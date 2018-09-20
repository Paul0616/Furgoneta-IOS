//
//  AssignLocationTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 16/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AssignLocationTableViewController: UITableViewController {

     var locations = [LocationModel]()
     var userId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        tableView.allowsSelection = false
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func onSwitch(_ sender: UISwitch) {
        locations[sender.tag].selected = sender.isOn
        var associatedLocations = [[:]] as [[String: Int]]
        for i in 0...locations.count-1 {
            if locations[i].selected {
                associatedLocations.append([Constants.LOCATION_NAME_KEY: locations[i].id])
            }
        }
        let swiftyJsonVar = JSON(associatedLocations)
        print(swiftyJsonVar)
        let value = swiftyJsonVar.rawString()! as String
        let param = [Constants.LOCATION_NAME_KEY: value, Constants.ID_KEY: userId] as [String : Any]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_USER_LOCATIONS, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {

                }
        }
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignLocationCell", for: indexPath) as! LocationToAssignTableViewCell
        cell.locationLabel.text = locations[indexPath.row].locationName
        cell.checkSwitch.tag = indexPath.row
        cell.checkSwitch.isOn = locations[indexPath.row].selected
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }

    func loadData(){
        locations.removeAll()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_ALL_LOCATIONS)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    for i in 0...(swiftyJsonVar.count-1){
                        let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                        let locationName = swiftyJsonVar[i][Constants.LOCATION_NAME_KEY].stringValue
                        guard let location = LocationModel(id: id, locationName: locationName) else {
                            fatalError("Unable to instantiate ProductModel")
                        }
                        self.locations += [location]
                    }
                    let param = [Constants.ID_KEY: self.userId] as [String: Int]
                    Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_USER_LOCATIONS, parameters: param)
                        .responseJSON{(responseData) -> Void in
                            if responseData.result.value != nil {
                                let swiftyJsonVar = JSON(responseData.result.value!)
                                if (swiftyJsonVar.count > 0){
                                    for i in 0...(self.locations.count-1) {
                                        for j in 0...(swiftyJsonVar.count-1) {
                                            let locationId = swiftyJsonVar[j][Constants.LOCATION_NAME_KEY].intValue
                                            if self.locations[i].id == locationId {
                                                self.locations[i].selected = true
                                            }
                                        }
                                    }
                                }
                                self.tableView.reloadData()
                            }
                    }
                    //self.tableView.reloadData()
                    //self.activityIndicator.stopAnimating()
                }
        }
        
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
