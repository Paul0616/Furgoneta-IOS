//
//  AddLocationsTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 09/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AddLocationsTableViewController: UITableViewController {

    var locations = [LocationModel]()
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        tableView.allowsSelection = false
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       //  self.navigationItem.rightBarButtonItem = self.editButtonItem

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deleteLocationButton(_ sender: UIButton) {
        let id = locations[sender.tag].id
        let param = [Constants.ID_KEY: id]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_DELETE_LOCATION, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    self.loadData()
                }
        }
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
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
        return locations.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        cell.locationLabel.text = locations[indexPath.row].locationName
        cell.editBtn.tag = indexPath.row
        cell.delBtn.tag = indexPath.row
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
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
    @IBAction func unwindFromLocation(segue: UIStoryboardSegue) {
        
        if let sourceViewController = segue.source as? LocationModalViewController,
            let locationName = sourceViewController.locationNameTextField.text
        {
            
            if sourceViewController.index != nil {
                let param = [Constants.LOCATION_NAME_KEY: locationName, Constants.ID_KEY: sourceViewController.index!] as [String : Any]
                Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_LOCATION, parameters: param)
                    .responseJSON{(responseData) -> Void in
                        if responseData.result.value != nil {
                            self.loadData()
                        }
                }
                
            } else {
                let param = [Constants.LOCATION_NAME_KEY: locationName]
                Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_LOCATION, parameters: param)
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
            
        case "editLocation":
            guard let locationModalViewController = segue.destination as? LocationModalViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEditBtn = sender as? UIButton else{
                fatalError("Unexpeted sender: \(String(describing: sender))")
            }
            
            let selectedLocationName = locations[selectedEditBtn.tag].locationName
            locationModalViewController.locationName = selectedLocationName
            locationModalViewController.index = locations[selectedEditBtn.tag].id
        case "addLocation":
            print("add product")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }


}
