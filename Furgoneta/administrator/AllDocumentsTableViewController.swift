//
//  AllDocumentsTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 18/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllDocumentsTableViewController: UITableViewController {

    var documents = [DocumentModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.allowsSelection = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    @IBAction func onClickBack(_ sender: Any) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return documents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if documents[indexPath.row].header {
            let cellDate = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! HeaderTableViewCell
            cellDate.dayDateLabel.text = documents[indexPath.row].day
            return cellDate
            
        } else {
            let cellDocument = tableView.dequeueReusableCell(withIdentifier: "documentsCell", for: indexPath) as! DocumentTableViewCell
            
            switch documents[indexPath.row].typeDocId {
                case Constants.DOCUMENT_TYPE_SUPPLY:
                    cellDocument.backgroundColor = UIColor(red:0.84, green:0.88, blue:0.96, alpha:1.0)
                case Constants.DOCUMENT_TYPE_CONSUMER:
                    cellDocument.backgroundColor = UIColor(red:0.87, green:0.90, blue:0.87, alpha:1.0)
                case Constants.DOCUMENT_TYPE_END_DAY:
                    cellDocument.backgroundColor = UIColor(red:0.89, green:0.80, blue:0.95, alpha:1.0)
                case Constants.DOCUMENT_TYPE_INVENTORY:
                    cellDocument.backgroundColor = UIColor(red:0.97, green:0.93, blue:0.85, alpha:1.0)
                default:
                    print("unknown document type")
            
            }
            cellDocument.documentTypeLabel.text = documents[indexPath.row].type?.uppercased()
            
            cellDocument.documentDateLabel.text = documents[indexPath.row].day
            cellDocument.documentIdLabel.text = String(documents[indexPath.row].id!)
            cellDocument.documentTimeLabel.text = documents[indexPath.row].hour
            cellDocument.locationLabel.text = documents[indexPath.row].location
            //let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("tapCell")))
            //cellParent.addGestureRecognizer(tapGesture)
            return cellDocument
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !documents[indexPath.row].header && documents[indexPath.row].typeDocId != Constants.DOCUMENT_TYPE_END_DAY {
            self.performSegue(withIdentifier: "showDocuments", sender: self)
        }
        if !documents[indexPath.row].header && documents[indexPath.row].typeDocId == Constants.DOCUMENT_TYPE_END_DAY {
            self.performSegue(withIdentifier: "showEndDay", sender: self)
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

    func loadData(){
        documents.removeAll()
        //     activityIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_ADMIN_VIEW_DOCS)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    for i in 0...(swiftyJsonVar.count-1){
                        let header = swiftyJsonVar[i][Constants.HEADER_KEY].boolValue
                        let day = swiftyJsonVar[i][Constants.DAY_KEY].stringValue
//                        var location: String? = nil
//                        var id: Int? = nil
//                        var hour: String? = nil
//                        var type: String? = nil
//                        var typeDocId: Int? = nil
//                        var status: Int? = nil
                        let location = swiftyJsonVar[i][Constants.LOCATION_NAME_KEY].stringValue
                        let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                        let hour = swiftyJsonVar[i][Constants.HOUR_KEY].stringValue
                        let type = swiftyJsonVar[i][Constants.TYPE_KEY].stringValue
                        let typeDocId = swiftyJsonVar[i][Constants.TYPE_DOC_ID_KEY].intValue
                        let status = swiftyJsonVar[i][Constants.STATUS_KEY].intValue
                        guard let document = DocumentModel(header: header, day: day, id: id, hour: hour,
                                                           type:type, typeDocId: typeDocId, status: status, location: location) else {
                            fatalError("Unable to instantiate ProductModel")
                        }
                        self.documents += [document]
                    }
                    self.tableView.reloadData()
                    // self.activityIndicator.stopAnimating()
                }
        }
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showDocuments",
            let destination = segue.destination as? DocumentViewController,
            let documentIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.documentTypeId = documents[documentIndex].typeDocId
            destination.docType = documents[documentIndex].type?.uppercased()
            destination.documentId = documents[documentIndex].id
            destination.documentDate = documents[documentIndex].day
        }
        if  segue.identifier == "showEndDay",
            let destination = segue.destination as? EndDayViewController,
            let documentIndex = tableView.indexPathForSelectedRow?.row
           
        {
             destination.finished = true
            destination.documentId = documents[documentIndex].id
            destination.documentDate = documents[documentIndex].day
//            destination.documentTypeId = documents[documentIndex].typeDocId
//            destination.docType = documents[documentIndex].type?.uppercased()
//            destination.documentId = documents[documentIndex].id
//            destination.documentDate = documents[documentIndex].day
        }
    }
  

}
