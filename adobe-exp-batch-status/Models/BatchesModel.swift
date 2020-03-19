//
//  BatchesModel {.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class BatchesModel: BatchesModelProtocol {
    
    var presenterCallback: BatchesPresenterProtocol?
    
    init(callback: BatchesPresenterProtocol) {
        self.presenterCallback = callback
    }
    
    func retrieveBatches(datasetId: String) {
        let headers = ["Authorization": "Bearer " + auth.token,
                       "x-api-key": authInfo.apiKey,
        "x-gw-ims-org-id": authInfo.imsOrg]
        let baseURL = URL(string: "https://platform.adobe.io/data/foundation/catalog/batches?\(datasetId)")!
        let request = NSMutableURLRequest(url: baseURL,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    var batches: [Batch] = []
                    for (id, datasetDictionary) in dictionary {
                        let dictionary = datasetDictionary as! NSDictionary
                        let batch = Batch(id: id as! String, lastUpdated: dictionary.value(forKey: "updated") as! Int, status: dictionary.value(forKey: "status") as! String)
                        batches.append(batch)
                    }
                    
                    self.presenterCallback?.updateBatches(batches: batches)
                } catch {
                    
                }
            }
        })

        task.resume()
    }
}
