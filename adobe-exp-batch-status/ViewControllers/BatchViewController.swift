//
//  BatchViewController.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import UIKit

class BatchViewController: UIViewController {
    var batchId: String = ""
    var presenter: SpecificBranchPresenterProtocol?
    var errors: [BatchError]?

    @IBOutlet weak var successfulFilesLabel: UILabel!
    @IBOutlet weak var failedFilesLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var errorCountLabel: UILabel!
    @IBOutlet weak var errorTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = batchId
        self.statusIcon.clipsToBounds = true
        self.statusIcon.layer.cornerRadius = (self.statusIcon.bounds.width / 2)
        errorView.alpha = 1
        errorTableView.alpha = 0
        self.errorTableView.delegate = self
        self.errorTableView.dataSource = self
        self.errorTableView.allowsSelection = false
        self.presenter = SpecificBatchPresenter(callback: self)
        presenter?.retrieveBatchData(id: batchId)
    }

}

extension BatchViewController: SpecificBranchViewControllerProtocol {
    func updateData(batch: BatchDetails?) {
        guard let batch = batch else {
            return
        }
        DispatchQueue.main.async {
            self.updateFailedFilesLabel(numFailed: batch.failedCount ?? 0)
            self.updateSuccessfulFilesLabel(numSuccessful: batch.successfulCount ?? 0)
            self.updateErrorCountLabel(numErrors: batch.errors.count)
            if (batch.errors.count > 0) {
                self.updateErrors(errorList: batch.errors)
                self.errorView.alpha = 0
                self.errorTableView.alpha = 1
            } else {
                self.errorView.alpha = 1
                self.errorTableView.alpha = 0
            }
            self.updateStartTimeLabel(startTime: batch.startedTime ?? 0)
            self.updateEndTimeLabel(endTime: batch.endedTime ?? 0)
            self.updateBatchStatus(status: batch.status)
        }
    }
    
    func updateBatchStatus(status: String) {
        switch status {
            case "success":
                self.statusIcon.backgroundColor = UIColor.green
                self.statusLabel.text = "Success"
                break
            case "failure", "failed":
                self.statusIcon.backgroundColor = UIColor.red
                self.statusLabel.text = "Failure"
                break
            case "aborted", "abandoned", "inactive":
                self.statusIcon.backgroundColor = UIColor.gray
                self.statusLabel.text = "Aborted"
                break
            default:
                self.statusIcon.backgroundColor = UIColor.yellow
                self.statusLabel.text = "Processing"
                break
        }
    }
    
    func updateSuccessfulFilesLabel(numSuccessful: Int) {
        self.successfulFilesLabel.text = String(numSuccessful)
    }
    
    func updateFailedFilesLabel(numFailed: Int) {
        self.failedFilesLabel.text = String(numFailed)
    }
    
    func updateStartTimeLabel(startTime: Int) {
        if (startTime > 0) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            
            let date = Date(milliseconds: startTime)
            self.startTimeLabel.text = formatter.string(from: date)
        } else {
            self.startTimeLabel.text = "--"
        }
    }
    
    func updateEndTimeLabel(endTime: Int) {
        if (endTime > 0) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            
            let date = Date(milliseconds: endTime)
            self.endTimeLabel.text = formatter.string(from: date)
        } else {
            self.endTimeLabel.text = "--"
        }
        
    }
    
    func updateErrorCountLabel(numErrors: Int) {
        self.errorCountLabel.text = String(numErrors)
    }
    
    func updateErrors(errorList: [BatchError]) {
        self.errors = errorList
        self.errorTableView.reloadData()
    }
}

extension BatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.errors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.errorTableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath) as! ErrorDetailsTableViewCell
        guard let error = self.errors?[indexPath.row] else {
            cell.errorCodeDetails.text = ""
            cell.errorCodeLabel.text = ""
            return cell
        }
        
        cell.errorCodeLabel.text = error.errorCode
        cell.errorCodeDetails.text = error.errorDescription
        
        return cell
    }
}
