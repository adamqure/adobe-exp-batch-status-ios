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
    var batches: [Batch] = []
    var start = 0
    var limit = 20
    
    init(callback: BatchesPresenterProtocol) {
        self.presenterCallback = callback
    }
    
    func retrieveBatches(datasetId: String) {
        let headers = ["Authorization": "Bearer " + auth.token,
                       "x-api-key": authInfo.apiKey,
        "x-gw-ims-org-id": authInfo.imsOrg]
        var baseURL = URLComponents(string: "https://platform.adobe.io/data/foundation/catalog/batches/?dataSet=\(datasetId)")!
        
        baseURL.queryItems = [
            URLQueryItem(name: "orderBy", value: "desc:created"),
            URLQueryItem(name: "start", value: String(start)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        var request = URLRequest(url: baseURL.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    for (id, datasetDictionary) in dictionary {
                        let dictionary = datasetDictionary as! NSDictionary
                        let batch = Batch(id: id as! String, lastUpdated: dictionary.value(forKey: "updated") as! Int, status: dictionary.value(forKey: "status") as! String)
                        self.batches.append(batch)
                    }
                    self.start += dictionary.count
                    
                    if (dictionary.count < self.limit) {
                        self.presenterCallback?.updateBatches(batches: self.batches)

                    } else {
                        self.presenterCallback?.updateBatches(batches: self.batches)
                        self.retrieveBatches(datasetId: datasetId)
                    }
                    
                } catch {
                    
                }
            }
        })

        task.resume()
    }
}
