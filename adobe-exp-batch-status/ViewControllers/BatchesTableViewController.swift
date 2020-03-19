//
//  BatchesTableViewController.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import UIKit

class BatchesTableViewController: UITableViewController {
    
    var datasetId: String = ""
    var datasetName: String = ""
    var presenter: BatchesPresenterProtocol?
    var batchesList = [Batch]()
    var filteredBatchesList = [Batch]()
    var selectedIndex = 0
    
    @IBOutlet weak var batchesSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = datasetName
        self.presenter = BatchesPresenter(callback: self)
        self.presenter?.retrieveBatches(dataset: self.datasetId)
        self.batchesSearchBar.delegate = self
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "batchSelected", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filteredBatchesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "batchTableCell", for: indexPath) as! BatchesTableViewCell
        let batch = filteredBatchesList[indexPath.row]
        cell.batchIdLabel.text = batch.id
        let status = Batch.stringToBatchStatus(statusString: batch.status)
        switch(status) {
            case .success:
                cell.statusLabel.text = "Success"
                cell.statusColorView.backgroundColor = UIColor.green
                break
            case .failure:
                cell.statusLabel.text = "Failed"
                cell.statusColorView.backgroundColor = UIColor.red
                break
            case .processing:
                cell.statusLabel.text = "Processing"
                cell.statusColorView.backgroundColor = UIColor.yellow
                break
            case .givenUp:
                cell.statusLabel.text = "Aborted"
                cell.statusColorView.backgroundColor = UIColor.gray
                break
        }
        
        let date = Date(milliseconds: batch.lastUpdated)
        let currentDate = Date()
        
        cell.lastModifiedLabel.text = currentDate.offsetFrom(date: date)
        
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         switch(segue.identifier) {
                   case "batchSelected":
                       let destination = segue.destination as? BatchViewController
                       if (destination != nil) {
                        destination?.batchId = self.filteredBatchesList[self.selectedIndex].id
                       }
                       break
                   default:
                       break
               }
    }

}

extension BatchesTableViewController: BatchesViewControllerProtocol {
    func updateBatches(batches: [Batch]) {
        DispatchQueue.main.async {
            self.batchesList = batches
            self.filteredBatchesList = batches
            self.tableView.reloadData()
        }
    }
}

extension BatchesTableViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchString = searchBar.text else {
            return
        }
        
        if (searchString == "") {
            self.filteredBatchesList = self.batchesList
        } else {
            self.filteredBatchesList = self.batchesList.filter {
                $0.id.lowercased().contains(searchString.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}
