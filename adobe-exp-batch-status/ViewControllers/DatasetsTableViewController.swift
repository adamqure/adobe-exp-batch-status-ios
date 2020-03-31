//
//  DatasetsTableViewController.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import UIKit

class DatasetsTableViewController: UITableViewController {
    
    @IBOutlet weak var datasetSearchBar: UISearchBar!
    
    var searchPresenting = false
    var presenter: DatasetsPresenterProtocol?
    var datasetsList = [Dataset]()
    var filteredDataSetsList = [Dataset]()
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = DatasetsPresenter(callback: self)
        self.datasetSearchBar.delegate = self
        presenter?.retrieveDatasets()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredDataSetsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataset = self.filteredDataSetsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "datasetTableCell", for: indexPath) as! DatasetsTableViewCell

        // Configure the cell...
        cell.datasetIdLabel.text = dataset.id
        cell.datasetNameLabel.text = dataset.name
        cell.statusLabel.text = dataset.state
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.datasetSelected(index: indexPath.row)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch(segue.identifier) {
            case "loginViewController":
                break
            case "datasetSelected":
                let destination = segue.destination as? BatchesTableViewController
                if (destination != nil) {
                    destination?.datasetId = self.filteredDataSetsList[self.selectedIndex].id
                    destination?.datasetName = self.filteredDataSetsList[self.selectedIndex].name
                }
                break
            default:
                break
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        present(secondVC, animated: true, completion: nil)
    }
}

extension DatasetsTableViewController: DatasetsViewControllerProtocol {
    func datasetSelected(index: Int) {
        self.selectedIndex = index
        performSegue(withIdentifier: "datasetSelected", sender: nil)
    }
    
    func searchSelected() {
        //Search Selected
        self.searchPresenting = !self.searchPresenting
        if (self.searchPresenting) {
            self.datasetSearchBar.isHidden = false
        } else {
            self.datasetSearchBar.isHidden = true
        }
    }
    
    func updateDatasets(datasets: [Dataset]) {
        DispatchQueue.main.async {
            self.datasetsList = datasets
            self.filteredDataSetsList = datasets
            self.tableView.reloadData()
        }
    }
    
    
}

extension DatasetsTableViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchString = searchBar.text else {
            return
        }
        
        if (searchText == "") {
            self.filteredDataSetsList = self.datasetsList
        } else {
            self.filteredDataSetsList = self.datasetsList.filter {
                $0.id.contains(searchString) || $0.name.lowercased().contains(searchString.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}
