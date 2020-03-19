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
    var pollingFrequency = 1
    var pollingid = ""
    
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
                        batch = BatchDetails(startedTime: dictionary.value(forKey: "started") as? Int, endedTime: dictionary.value(forKey: "completed") as? Int, status: dictionary.value(forKey: "status") as! String, successfulCount: dictionary.value(forKey: "recordCount") as? Int, failedCount: dictionary.value(forKey: "failedRecordCount") as? Int, errors: errorArray)
                    }
                    
                    self.presenterCallback.updateBatchData(batch: batch)
                } catch {
                    print(error)
                }
            }
        })

        task.resume()
    }
    
    func beginPolling(id: String) {
        //Start the polling
    }
    
    func cancelPolling(id: String) {
        //End the polling
    }
    
    deinit {
//        cancelPolling(id: <#T##String#>)
    }
}
