//
//  SpecificBatchModel.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class SpecificBatchModel: SpecificBranchModelProtocol {
    var presenterCallback: SpecificBranchPresenterProtocol
    var isPolling = false
    var pollingFrequency: TimeInterval = 5
    var pollingid = ""
    var pollingTimer: Timer?
    let pollingMax: TimeInterval = 300
    
    init(presenter: SpecificBranchPresenterProtocol) {
        self.presenterCallback = presenter
    }
    
    func retrieveBatchData(id: String) {
        self.pollingid = id
        let headers = ["Authorization": "Bearer " + auth.token,
                       "x-api-key": authInfo.apiKey,
        "x-gw-ims-org-id": authInfo.imsOrg]
        let baseURL = URL(string: "https://platform.adobe.io/data/foundation/catalog/batches/\(id)")!
        let request = NSMutableURLRequest(url: baseURL,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let dataDetails = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    var batch: BatchDetails? = nil
                    for (_, dictionary) in dataDetails {
                        let dictionary = dictionary as! NSDictionary
                        var errorArray = [BatchError]()
                        let errors = dictionary.value(forKey: "errors") as? NSArray
                        if (errors != nil) {
                            for error in errors! {
                                let errorDetails = error as! [String:Any]
                                let batchError = BatchError(errorCode: errorDetails["code"] as! String, errorDescription: errorDetails["description"] as! String)
                                errorArray.append(batchError)
                            }
                        }
                        
                        let metrics = dictionary.value(forKey: "metrics") as! NSDictionary
                        let status = dictionary.value(forKey: "status") as! String
                        
                        if (self.isProcessing(status: status)) {
                            if (self.pollingFrequency < self.pollingMax) {
                                self.pollingFrequency += 5
                            }
                            if (!self.isPolling) {
                                self.isPolling = true
                                self.beginPolling(id: id)
                            }
                        } else {
                            self.isPolling = false
                            self.cancelPolling(id: id)
                        }
                        
                        batch = BatchDetails(startedTime: dictionary.value(forKey: "started") as? Int, endedTime: dictionary.value(forKey: "completed") as? Int, status: status, successfulCount: metrics.value(forKey: "outputRecordCount") as? Int, failedCount: (metrics.value(forKey: "inputRecordCount") as? Int ?? 0) - (metrics.value(forKey: "outputRecordCount") as? Int ?? 0), errors: errorArray)
                        
                    }
                    
                    self.presenterCallback.updateBatchData(batch: batch)
                } catch {
                    print(error)
                }
            }
        })

        task.resume()
    }
    
    func isProcessing(status: String) -> Bool {
        let batchStatus: Batch.BatchStatus = Batch.stringToBatchStatus(statusString: status)
        switch batchStatus {
            case .processing:
                return true
            default:
                return false
        }
    }
    
    func beginPolling(id: String) {
        //Start the polling
        self.pollingid = id
        self.pollingTimer = Timer.scheduledTimer(timeInterval: pollingFrequency, target: self, selector: #selector(poll), userInfo: nil, repeats: true)
    }
    
    @objc func poll() {
        self.retrieveBatchData(id: self.pollingid)
    }
    
    func cancelPolling(id: String) {
        //End the polling
        self.pollingTimer?.invalidate()
    }
    
    deinit {
        cancelPolling(id: self.pollingid)
    }
}
